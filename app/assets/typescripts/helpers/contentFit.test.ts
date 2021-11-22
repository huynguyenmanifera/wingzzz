import contentFit from "./contentFit";

describe("contentFit", () => {
  describe("when aspects ratios are equal", () => {
    describe("when content is smaller than container", () => {
      it("returns container size", () => {
        expect(
          contentFit({
            content: {
              width: 150,
              height: 100,
            },
            container: {
              width: 300,
              height: 200,
            },
          })
        ).toEqual({
          width: 300,
          height: 200,
        });
      });
    });

    describe("when content has same size as container", () => {
      it("returns container size", () => {
        expect(
          contentFit({
            content: {
              width: 300,
              height: 200,
            },
            container: {
              width: 300,
              height: 200,
            },
          })
        ).toEqual({
          width: 300,
          height: 200,
        });
      });
    });

    describe("when content is bigger than container", () => {
      it("returns container size", () => {
        expect(
          contentFit({
            content: {
              width: 600,
              height: 400,
            },
            container: {
              width: 300,
              height: 200,
            },
          })
        ).toEqual({
          width: 300,
          height: 200,
        });
      });
    });
  });

  describe("when aspect ratios are not equal", () => {
    describe("when content is less wide than container", () => {
      it("scales down to width of the container", () => {
        expect(
          contentFit({
            content: {
              width: 100,
              height: 50,
            },
            container: {
              width: 300,
              height: 200,
            },
          })
        ).toEqual({
          width: 300,
          height: 150,
        });
      });
    });

    describe("when content is wider than container", () => {
      it("scales down to height of the container", () => {
        expect(
          contentFit({
            content: {
              width: 600,
              height: 50,
            },
            container: {
              width: 300,
              height: 200,
            },
          })
        ).toEqual({
          width: 300,
          height: 25,
        });
      });
    });
  });
});
