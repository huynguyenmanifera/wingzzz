import { Book } from "epubjs";

const pageListLength = (book: Book): Promise<number> => {
  return new Promise((resolve) => {
    // It seems like loading navigation will also load
    // the book's pagelist, while book.loaded.pageList.then
    // does not. Possible bug in EPUBjs?
    book.loaded.navigation.then((_navigation) => {
      const pageList: any = book.pageList;
      resolve(pageList.pages.length);
    });
  });
};

const tocLength = (book: Book): Promise<number> => {
  return new Promise((resolve) => {
    book.loaded.navigation.then((navigation) => {
      resolve(navigation.toc.length);
    });
  });
};

const bookLength = (book: Book): Promise<number> => {
  // Some desktop publishing programs use 'epub:type="page-list"'
  // for fixed layouts (e.g. Adobe InDesign), while others use
  // 'epub:type="toc"' (e.g. Apple Pages). Therefore we use the
  // latter as fallback in cage the 'page-list' is missing.
  return new Promise((resolve) => {
    pageListLength(book).then((pages) => {
      if (pages > 0) {
        resolve(pages);
      } else {
        tocLength(book).then((tocLength) => {
          console.warn(
            "No pageList found in EPUB, using toc length as fallback."
          );

          // Assume cover page is not included in toc (as is the case
          // for Apple Pages).Therefore increase by 1.
          resolve(tocLength + 1);
        });
      }
    });
  });
};

export default bookLength;
