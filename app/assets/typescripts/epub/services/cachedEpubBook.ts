import * as Epub from "epubjs";

// We currently only cache a single Epub.Book at a time to avoid
// potential memory issues, partly because we are using turbolinks.
let _cachedEpubBook: { url: string; book: Epub.Book } | null = null;
const cachedEpubBook = (url: string): Epub.Book => {
  if (_cachedEpubBook && _cachedEpubBook.url === url) {
    return _cachedEpubBook.book;
  } else {
    _cachedEpubBook = {
      url: url,
      book: new Epub.Book(url),
    };
    return _cachedEpubBook.book;
  }
};

export default cachedEpubBook;
