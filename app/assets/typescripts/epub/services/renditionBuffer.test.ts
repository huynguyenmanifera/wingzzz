import { renditionsBefore, renditionsAhead } from "./renditionBuffer";
import { NavState } from "./navigationBehavior";
import { BookType, Layout } from "../Book";

const navState: NavState = {
  currentPage: 4,
  book: {
    layout: Layout.TwoPages,
    totalPages: 11,
    epubFileURL: "https://www.example.org/epub-sample",
    coverURL: "https://www.example.org/epub-sample",
    type: BookType.Regular,
  },
};

describe("renditionBuffer", () => {
  describe("#renditionsAhead", () => {
    describe("when amount is 0", () => {
      it("returns empty array", () => {
        expect(
          renditionsAhead({
            ...navState,
            currentPage: 1,
          })(0)
        ).toEqual([]);
      });
    });

    describe("when amount is 2", () => {
      describe("when two next renditions exist", () => {
        it("returns next two renditions", () => {
          expect(
            renditionsAhead({
              ...navState,
              currentPage: 1,
            })(2)
          ).toEqual([
            {
              layout: Layout.TwoPages,
              leftPage: 2,
              rightPage: 3,
            },
            {
              layout: Layout.TwoPages,
              leftPage: 4,
              rightPage: 5,
            },
          ]);
        });
      });

      describe("when only one next rendition exists", () => {
        it("returns only next rendition", () => {
          expect(
            renditionsAhead({
              ...navState,
              book: {
                ...navState.book,
                totalPages: 3,
              },
              currentPage: 1,
            })(2)
          ).toEqual([
            {
              layout: Layout.TwoPages,
              leftPage: 2,
              rightPage: 3,
            },
          ]);
        });
      });

      describe("when no next rendition exists", () => {
        it("returns empty array", () => {
          expect(
            renditionsAhead({
              ...navState,
              book: {
                ...navState.book,
                totalPages: 1,
              },
              currentPage: 1,
            })(2)
          ).toEqual([]);
        });
      });
    });
  });

  describe("#renditionsBefore", () => {
    describe("when amount is 0", () => {
      it("returns empty array", () => {
        expect(
          renditionsBefore({
            ...navState,
            book: {
              ...navState.book,
              totalPages: 4,
            },
            currentPage: 11,
          })(0)
        ).toEqual([]);
      });
    });

    describe("when amount is 2", () => {
      describe("when two previous renditions exist", () => {
        it("returns previous two renditions", () => {
          expect(
            renditionsBefore({
              ...navState,
              currentPage: 4,
            })(2)
          ).toEqual([
            {
              layout: Layout.SinglePage,
              page: 1,
            },
            {
              layout: Layout.TwoPages,
              leftPage: 2,
              rightPage: 3,
            },
          ]);
        });
      });

      describe("when only one previous rendition exists", () => {
        it("returns only previous rendition", () => {
          expect(
            renditionsBefore({
              ...navState,
              currentPage: 2,
            })(2)
          ).toEqual([
            {
              layout: Layout.SinglePage,
              page: 1,
            },
          ]);
        });
      });

      describe("when no previous renditions exists", () => {
        it("returns empty array", () => {
          expect(
            renditionsBefore({
              ...navState,
              book: {
                ...navState.book,
                totalPages: 1,
              },
              currentPage: 1,
            })(2)
          ).toEqual([]);
        });
      });
    });
  });
});
