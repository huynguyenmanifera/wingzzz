const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs-extra");
const pdf2epub = require("./pdf2epub");

const utils = require("./utils");
const jobs = require("./jobs");

const tmpDirectory = "tmp/";
fs.mkdirpSync(tmpDirectory);

const epubDirectory = path.join(tmpDirectory, "epubs");
fs.mkdirpSync(epubDirectory);

const app = express();
const upload = multer({ dest: path.join(tmpDirectory, "uploads") });
const port = process.env.PORT || 3000;

app.set("view engine", "ejs");

/**
 * Render index page
 */
app.get("/", (_req, res) => {
  res.setHeader("Cache-Control", "max-age=0, private, must-revalidate");
  res.render("index");
});

/**
 * Renders status page.
 * User is sent here when conversion is in progress.
 */
app.get("/converting/:jobId", (req, res) => {
  res.setHeader("Cache-Control", "max-age=0, private, must-revalidate");

  const job = jobs.get(req.params.jobId);

  if (!job) {
    return res.status(404).send("Job not found");
  }

  const notify = req.query.notify == "true";
  res.render("converting", { jobId: job.id, notify: notify });
});

/**
 * Serves created EPUB files. File is cleaned up after download.
 */
app.get("/epubs/:file", (req, res) => {
  res.on("finish", () => {
    if (!req.params) return;

    const epubFile = path.join(epubDirectory, req.params.file);
    fs.remove(epubFile);
  });

  res.sendFile(req.params.file, { root: epubDirectory });
});

/**
 * Server Sent Event stream to update browser of conversion progress.
 */
app.get("/jobs/:jobId/status", function (req, res) {
  const job = jobs.get(req.params.jobId);

  if (!job) {
    return res.status(400).send("Invalid job id");
  }

  utils.startSSE(res);

  /**
   * The EPUB conversion process does not have any output unfortunately,
   * so we produce a fake progress event every second.
   */
  const progressTimer = setInterval(() => {
    console.log("Converting...");
    utils.sendSSEvent(res, "progress", {});
  }, 1 * 1000);

  job.once("completed", (epubFile) => {
    console.info("Conversion completed");
    clearInterval(progressTimer);

    utils.sendSSEvent(res, "completed", {
      url: `/epubs/${epubFile}`,
    });
  });

  job.once("error", (message) => {
    console.error("PDF conversion failed:", message);
    clearInterval(progressTimer);

    utils.sendSSEvent(res, "failed", {
      error: `There was an error converting this file: ${message}.`,
    });
  });

  res.on("close", () => {
    clearInterval(progressTimer);
    jobs.delete(job);

    res.end();
  });
});

/**
 * Handles form uploads, starts EPUB conversion process.
 * User is redirected to status page where progress is tracked.
 */
app.post("/api/convert", upload.single("pdf"), async function (req, res) {
  console.log("Converting", req.file.originalname);

  const reqTmpDirectory = await fs.mkdtemp(path.join(tmpDirectory, "req"));
  const job = jobs.create();

  const filename = utils.replaceExt(req.file.originalname, "epub");
  const fileWriter = fs.createWriteStream(path.join(epubDirectory, filename));

  // Not using async await here on purpose, we _don't_ want the request
  // to wait on the conversion to prevent browser/request timeouts.
  pdf2epub(req.file.path, fileWriter, reqTmpDirectory)
    .then(() => {
      fs.remove(reqTmpDirectory);
      fs.remove(req.file.path);

      job.emit("completed", filename);
    })
    .catch((e) => {
      job.emit("error", e.toString());
    });

  const notify = req.body.notify == "on";
  res.redirect(`/converting/${job.id}?notify=${notify}`);
});

app.listen(port, () =>
  console.log(`Server listening at http://localhost:${port}`)
);

process.on("SIGINT", function () {
  process.exit();
});
