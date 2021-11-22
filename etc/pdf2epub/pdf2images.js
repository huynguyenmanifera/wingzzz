const fs = require("fs-extra");
const path = require("path");
const { spawn } = require("child_process");

module.exports = async function (pdfFilePath, tmpDirectory) {
  const outputDirectory = path.join(tmpDirectory, "images");
  await fs.mkdirp(outputDirectory);

  /**
   * Creates a JPG file per page in the PDF:
   * page-1.jpg
   * page-2.jpg
   * page-3.jpg
   *
   * etc
   */
  const pdftoppm = spawn(
    "pdftoppm",
    [
      "-jpeg",
      "-jpegopt",
      "quality=95,progressive=y,optimize=y",
      pdfFilePath,
      path.join(outputDirectory, "page"),
    ],
    { stdio: "inherit" }
  );

  return new Promise((resolve, reject) => {
    pdftoppm.on("close", (code) => {
      if (code == 0) resolve(outputDirectory);
      else reject(code);
    });
  });
};
