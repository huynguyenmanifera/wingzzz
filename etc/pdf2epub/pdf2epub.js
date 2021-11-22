const pdf2images = require("./pdf2images");
const imgs2epub = require("./imgs2epub");

module.exports = async function (pdfFilePath, outputStream, tmpDirectory) {
  const imagesPath = await pdf2images(pdfFilePath, tmpDirectory);
  return imgs2epub(imagesPath, outputStream, tmpDirectory);
};
