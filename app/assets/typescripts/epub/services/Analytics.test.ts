import Analytics from "./Analytics";

const mockDate = (value: number) => {
  jest.spyOn(global.Date, "now").mockImplementationOnce(() => value);
};

afterEach(() => {
  jest.clearAllMocks();
});

describe("Analytics", () => {
  describe("#bookProgressChangeEvent", () => {
    it("returns BookProgressChangeEvent", () => {
      mockDate(1587022542090);

      const analytics = Analytics.bookOpened(42, {
        currentRendition: 2,
        totalRenditions: 11,
      });

      mockDate(1587023464082);

      const event1 = analytics.bookProgressChangeEvent({
        currentRendition: 3,
        totalRenditions: 11,
      });

      mockDate(1587023514183);

      const event2 = analytics.bookProgressChangeEvent({
        currentRendition: 6,
        totalRenditions: 11,
      });

      expect(event1).toEqual({
        name: "book_progress_change",
        properties: {
          book_id: 42,
          book_opened_at: 1587022542090,
          new_progress: 0.2,
          previous_progress: 0.1,
        },
      });

      expect(event2).toEqual({
        name: "book_progress_change",
        properties: {
          book_id: 42,
          book_opened_at: 1587022542090,
          new_progress: 0.5,
          previous_progress: 0.2,
        },
      });
    });
  });
});
