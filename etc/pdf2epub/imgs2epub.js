const fs = require("fs-extra");
const util = require("util");
const path = require("path");
const mime = require("mime");
const nunjucks = require("nunjucks");
const archiver = require("archiver");
const sharp = require("sharp");

const collator = new Intl.Collator(undefined, {
  numeric: true,
  sensitivity: "base",
});
nunjucks.configure("templates", { autoescape: true });

const templatesDirectory = path.resolve(__dirname, "templates");
const epubTemplateDirectory = path.resolve(templatesDirectory, "epub");

const imgFiles = async (directory) => {
  return (await util.promisify(fs.readdir)(directory)).filter((f) =>
    [".jpg", ".jpeg", ".png"].includes(path.extname(f))
  );
};

const imageDimensions = async (imgFile) => {
  const meta = await sharp(imgFile).metadata();
  return {
    width: meta.width,
    height: meta.height,
  };
};

/**
 * Render an EPUB based on a list of images.
 * Images are sorted numerically based on filename, so for example:
 *
 *   [page-3.jpg, page-1.jpg, page-2.jpg]
 *
 * Will be sorted into
 *
 *   [page-1.jpg, page-2.jpg, page-3.jpg]
 *
 * And EPUB pages will be rendered in this order.
 * @param { list of paths to image files } imgFiles
 * @param { directory containing image files } inputDirectory
 */
const render = async (imgFiles, inputDirectory) => {
  const pagePromises = imgFiles
    .sort(collator.compare)
    .map(async (imgFile, index) => {
      return {
        id: `page-${index + 1}`,
        path: imgFile,
        mediaType: mime.getType(path.extname(imgFile)),
        dimensions: await imageDimensions(
          path.resolve(inputDirectory, imgFile)
        ),
      };
    });

  const pages = await Promise.all(pagePromises);
  const context = { pages };

  const content = nunjucks.render("content.opf.njk", context);
  const toc = nunjucks.render("toc.xhtml.njk", context);
  const renderedPages = pages.map((page) => {
    return {
      id: page.id,
      contents: nunjucks.render("page.xhtml.njk", {
        image: {
          path: page.path,
          dimensions: page.dimensions,
        },
      }),
      image: page.path,
    };
  });

  return { content, toc, pages: renderedPages };
};

/**
 * Write EPUB content files to a directory of choice.
 * Starts from a set of template files in ./templates.
 *
 * @param {directory containing image files} inputDirectory
 * @param {directory to write epub content files to} outputDirectory
 * @param {description of EPUB pages, produced by @see {@link render}} renderResult
 */
const writeEpubData = async (inputDirectory, outputDirectory, renderResult) => {
  await fs.copy(epubTemplateDirectory, outputDirectory);
  await fs.mkdirp(path.resolve(outputDirectory, "OEBPS", "images"));

  const writePages = () =>
    renderResult.pages.map((page) =>
      fs.writeFile(
        path.resolve(outputDirectory, "OEBPS", `${page.id}.xhtml`),
        page.contents
      )
    );

  const writeImageFiles = () =>
    renderResult.pages.map((page) =>
      fs.copyFile(
        path.resolve(inputDirectory, page.image),
        path.resolve(outputDirectory, "OEBPS", "images", page.image)
      )
    );

  return await Promise.all([
    fs.writeFile(
      path.resolve(outputDirectory, "OEBPS", "toc.xhtml"),
      renderResult.toc
    ),
    fs.writeFile(
      path.resolve(outputDirectory, "OEBPS", "content.opf"),
      renderResult.content
    ),
    ...writePages(),
    ...writeImageFiles(),
  ]);
};

/**
 * Produce EPUB (zip) file.
 *
 * @param {path to EPUB content files} epubDataPath
 * @param {stream where EPUB file will be written to} outputEpubStream
 */
const createEpubFile = async function (epubDataPath, outputEpubStream) {
  return new Promise(function (resolve, reject) {
    const archive = archiver("zip");

    archive.on("finish", resolve);

    archive.on("warning", function (err) {
      if (err.code === "ENOENT") {
        console.warn(err);
      } else {
        reject(err);
      }
    });

    archive.on("error", function (err) {
      reject(err);
    });

    archive.pipe(outputEpubStream);

    /* Add _contents_ of EPUB data directory to the zip */
    archive.directory(epubDataPath, false);

    /* No more data to add */
    archive.finalize();
  });
};

module.exports = async function (
  inputDirectory,
  outputEpubStream,
  tmpDirectory
) {
  const images = await imgFiles(inputDirectory);
  const renderResult = await render(images, inputDirectory);

  const epubDataPath = path.join(tmpDirectory, "epub");
  await writeEpubData(inputDirectory, epubDataPath, renderResult);

  return createEpubFile(epubDataPath, outputEpubStream);
};
