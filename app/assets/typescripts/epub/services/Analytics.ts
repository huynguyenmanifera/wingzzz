import { Progress, progressRatio } from "./progress";

export type BookProgressChangeEvent = {
  name: "book_progress_change";
  properties: {
    book_id: number;
    book_opened_at: number;
    previous_progress: number;
    new_progress: number;
  };
};

export type AnalyticsEvent = BookProgressChangeEvent;

export default class Analytics {
  static bookOpened(bookId: number, initialProgress: Progress): Analytics {
    return new Analytics(bookId, initialProgress, Date.now());
  }

  private bookOpenedAt: number;
  private bookId: number;
  private lastReportedProgress: Progress;

  private constructor(
    bookId: number,
    initialProgress: Progress,
    bookOpenedAt: number
  ) {
    this.bookId = bookId;
    this.lastReportedProgress = initialProgress;
    this.bookOpenedAt = bookOpenedAt;
  }

  public bookProgressChangeEvent(progress: Progress): BookProgressChangeEvent {
    const previousProgress = progressRatio(this.lastReportedProgress);
    const newProgress = progressRatio(progress);

    this.lastReportedProgress = progress;

    return {
      name: "book_progress_change",
      properties: {
        ...this.defaultAttributes,
        previous_progress: previousProgress,
        new_progress: newProgress,
      },
    };
  }

  private get defaultAttributes() {
    return {
      book_id: this.bookId,
      book_opened_at: this.bookOpenedAt,
    };
  }
}
