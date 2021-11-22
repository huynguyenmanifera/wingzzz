const os = require("os");
const path = require("path");
const fs = require("fs-extra");
const pdf2epub = require("./pdf2epub");

const main = async () => {
  const inputPdfPath = path.resolve(process.cwd(), process.argv[2]);
  const epubTargetPath = path.resolve(process.cwd(), process.argv[3]);

  const tmpDirectory = await fs.mkdtemp(path.join(os.tmpdir(), "wz-"));
  const outputStream = fs.createWriteStream(epubTargetPath);

  return pdf2epub(inputPdfPath, outputStream, tmpDirectory);
};

main();
