import Book, { Layout } from "../Book";
import * as _ from "lodash";

export type SinglePage = { layout: Layout.SinglePage; page: number };
export type TwoPages = {
  layout: Layout.TwoPages;
  leftPage: number;
  rightPage: number;
};
export type Rendition = SinglePage | TwoPages;

export interface NavState {
  book: Book;
  currentPage: number;
}

export function rendition(navState: NavState): Rendition {
  const allRenditions = renditions(navState.book);

  const rendition = renditions(navState.book).find((rendition) => {
    return visiblePages(rendition).includes(navState.currentPage);
  });

  return rendition ? rendition : <Rendition>_.first(allRenditions);
}

export function next(navState: NavState): NavState {
  const allRenditions = renditions(navState.book);

  const nextRendition = <Rendition>(() => {
    const index = allRenditions.findIndex((rendition) => {
      return visiblePages(rendition).includes(navState.currentPage);
    });

    if (index < 0) {
      return _.first(allRenditions);
    } else if (index > allRenditions.length - 2) {
      return _.last(allRenditions);
    } else return allRenditions[index + 1];
  })();

  return {
    book: navState.book,
    currentPage: identifyingPage(nextRendition),
  };
}

export function previous(navState: NavState): NavState {
  const allRenditions = renditions(navState.book);

  const previousRendition = <Rendition>(() => {
    const index = allRenditions.findIndex((rendition) => {
      return visiblePages(rendition).includes(navState.currentPage);
    });

    if (index <= 0) {
      return _.first(allRenditions);
    } else if (index > allRenditions.length - 1) {
      return _.last(allRenditions);
    } else return allRenditions[index - 1];
  })();

  return {
    book: navState.book,
    currentPage: identifyingPage(previousRendition),
  };
}

export function first(book: Book): NavState {
  const firstRendition = <Rendition>_.first(renditions(book));

  return {
    book,
    currentPage: identifyingPage(firstRendition),
  };
}

export function last(book: Book): NavState {
  const lastRendition = <Rendition>_.last(renditions(book));

  return {
    book,
    currentPage: identifyingPage(lastRendition),
  };
}

function renditions(book: Book): Rendition[] {
  switch (book.layout) {
    case Layout.SinglePage:
      return _.range(1, book.totalPages + 1).map((page) => {
        return {
          layout: Layout.SinglePage,
          page,
        };
      });

    case Layout.TwoPages:
      const coverPage: Rendition[] = [
        {
          layout: Layout.SinglePage,
          page: 1,
        },
      ];

      const succeedingPages: Rendition[] = _.range(
        2,
        book.totalPages + 1,
        2
      ).map((page) => {
        if (page < book.totalPages) {
          return {
            layout: Layout.TwoPages,
            leftPage: page,
            rightPage: page + 1,
          };
        } else {
          return {
            layout: Layout.SinglePage,
            page,
          };
        }
      });

      return coverPage.concat(succeedingPages);
  }
}

function identifyingPage(rendition: Rendition): number {
  switch (rendition.layout) {
    case Layout.SinglePage:
      return rendition.page;

    case Layout.TwoPages:
      return rendition.leftPage;
  }
}

function visiblePages(rendition: Rendition): number[] {
  switch (rendition.layout) {
    case Layout.SinglePage:
      return [rendition.page];

    case Layout.TwoPages:
      return [rendition.leftPage, rendition.rightPage];
  }
}
