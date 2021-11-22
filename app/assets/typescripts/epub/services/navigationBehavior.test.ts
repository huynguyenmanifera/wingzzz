import { rendition, first, last, next, previous } from "./navigationBehavior";
import Book, { BookType, Layout } from "../Book";

let book: Book = {
  layout: Layout.TwoPages,
  totalPages: 10,
  epubFileURL: "https//www.example.org",
  coverURL: "https//www.example.org",
  type: BookType.Regular,
};

describe("#rendition", () => {
  describe("Layout: Two Pages", () => {
    describe("cover page", () => {
      it("is rendered as a single page", () => {
        expect(
          rendition({
            book,
            currentPage: 1,
          })
        ).toEqual({
          layout: Layout.SinglePage,
          page: 1,
        });
      });
    });

    describe("page 2", () => {
      it("shows page 2 and 3", () => {
        expect(
          rendition({
            book,
            currentPage: 2,
          })
        ).toEqual({
          layout: Layout.TwoPages,
          leftPage: 2,
          rightPage: 3,
        });
      });
    });

    describe("page 3", () => {
      it("shows page 2 and 3", () => {
        expect(
          rendition({
            book,
            currentPage: 3,
          })
        ).toEqual({
          layout: Layout.TwoPages,
          leftPage: 2,
          rightPage: 3,
        });
      });
    });

    describe("last even page", () => {
      it("it shows only last page", () => {
        expect(
          rendition({
            book,
            currentPage: 10,
          })
        ).toEqual({
          layout: Layout.SinglePage,
          page: 10,
        });
      });
    });
  });

  describe("Layout: Single Page", () => {
    describe("page 2", () => {
      it("shows page 2", () => {
        expect(
          rendition({
            book: {
              ...book,
              layout: Layout.SinglePage,
            },
            currentPage: 2,
          })
        ).toEqual({
          layout: Layout.SinglePage,
          page: 2,
        });
      });
    });
  });
});

describe("#first", () => {
  it("returns first page", () => {
    expect(first(book)).toEqual({
      book,
      currentPage: 1,
    });
  });
});

describe("#last", () => {
  it("returns last page", () => {
    expect(last(book)).toEqual({
      book,
      currentPage: 10,
    });
  });
});

describe("#next", () => {
  describe("page 2", () => {
    it("returns page 4", () => {
      expect(
        next({
          book,
          currentPage: 2,
        })
      ).toEqual({
        book,
        currentPage: 4,
      });
    });
  });

  describe("page 3", () => {
    it("returns page 4", () => {
      expect(
        next({
          book,
          currentPage: 3,
        })
      ).toEqual({
        book,
        currentPage: 4,
      });
    });
  });
});

describe("#previous", () => {
  describe("page 4", () => {
    it("returns page 2", () => {
      expect(
        previous({
          book,
          currentPage: 4,
        })
      ).toEqual({
        book,
        currentPage: 2,
      });
    });
  });

  describe("page 5", () => {
    it("returns page 2", () => {
      expect(
        previous({
          book,
          currentPage: 5,
        })
      ).toEqual({
        book,
        currentPage: 2,
      });
    });
  });
});
