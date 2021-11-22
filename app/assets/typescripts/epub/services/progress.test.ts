import * as Epub from "epubjs";

import { progress } from "./progress";
import Book, { Layout } from "../Book";

const book = {
  layout: Layout.TwoPages,
  totalPages: 23,
  epubFileURL: "https//www.example.org/epub-sample",
} as Book;

describe("progress", () => {
  describe("#progress", () => {
    describe("totalRenditions", () => {
      describe("even amount of pages", () => {
        expect(
          progress({
            book: {
              ...book,
              totalPages: 6,
            },
            currentPage: 2,
          }).totalRenditions
        ).toEqual(4);
      });

      describe("odd amount of pages", () => {
        it("returns the total of renditions", () => {
          expect(
            progress({
              book: {
                ...book,
                totalPages: 7,
              },
              currentPage: 2,
            }).totalRenditions
          ).toEqual(4);
        });
      });
    });

    describe("currentRendition", () => {
      it("return correct current rendition", () => {
        expect(
          progress({
            book: {
              ...book,
              totalPages: 6,
            },
            currentPage: 4,
          }).currentRendition
        ).toEqual(3);
      });

      describe("when current page is the right page of the rendition", () => {
        it("returns correct current rendition", () => {
          expect(
            progress({
              book: {
                ...book,
                totalPages: 6,
              },
              currentPage: 5,
            }).currentRendition
          ).toEqual(3);
        });
      });
    });
  });
});
