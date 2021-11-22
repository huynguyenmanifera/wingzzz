import { UIVisibility } from "./UIVisibility";

describe("UIVisibility", () => {
  describe("#show", () => {
    describe("when channel did not send command before", () => {
      it("adds a new command", () => {
        const visibility = new UIVisibility({
          currentTime: 1000,
          state: {
            commands: [
              {
                channel: "unrelated_channel",
                visibleUntil: 2000,
              },
            ],
          },
        });

        const result = visibility.show({
          channel: "new_channel",
          ms: 500,
        });

        expect(result).toEqual({
          commands: [
            {
              channel: "unrelated_channel",
              visibleUntil: 2000,
            },
            {
              channel: "new_channel",
              visibleUntil: 1500,
            },
          ],
        });
      });
    });
  });

  describe("when channel did already send a command", () => {
    it("updates the existing command", () => {
      const visibility = new UIVisibility({
        currentTime: 1000,
        state: {
          commands: [
            {
              channel: "existing_channel",
              visibleUntil: 3000,
            },
            {
              channel: "unrelated_channel",
              visibleUntil: 2000,
            },
          ],
        },
      });

      const result = visibility.show({
        channel: "existing_channel",
        ms: 500,
      });

      expect(result).toEqual({
        commands: [
          {
            channel: "existing_channel",
            visibleUntil: 1500,
          },
          {
            channel: "unrelated_channel",
            visibleUntil: 2000,
          },
        ],
      });
    });
  });
});

describe("#isVisible", () => {
  describe("when all visibleUntil's are before current time", () => {
    const visibility = new UIVisibility({
      currentTime: 5000,
      state: {
        commands: [
          { channel: "a", visibleUntil: 4000 },
          { channel: "b", visibleUntil: 3500 },
          { channel: "a", visibleUntil: 2500 },
        ],
      },
    });

    const result = visibility.isVisible;

    expect(result).toEqual(false);
  });

  describe("when there exists a visibleUntil after current time", () => {
    const visibility = new UIVisibility({
      currentTime: 5000,
      state: {
        commands: [
          { channel: "a", visibleUntil: 4000 },
          { channel: "b", visibleUntil: 6200 },
          { channel: "a", visibleUntil: 2500 },
        ],
      },
    });

    const result = visibility.isVisible;

    expect(result).toEqual(true);
  });
});

describe("#hide", () => {
  describe("when channel did not send command before", () => {
    it("does not change the state", () => {
      const visibility = new UIVisibility({
        currentTime: 1000,
        state: {
          commands: [
            {
              channel: "unrelated_channel",
              visibleUntil: 2000,
            },
          ],
        },
      });

      const result = visibility.hide({
        channel: "new_channel",
        delayMs: 500,
      });

      expect(result).toEqual({
        commands: [
          {
            channel: "unrelated_channel",
            visibleUntil: 2000,
          },
        ],
      });
    });
  });

  describe("when channel did send a command before", () => {
    describe("when channel is currently visible", () => {
      it("updates the existing command", () => {
        const visibility = new UIVisibility({
          currentTime: 1000,
          state: {
            commands: [
              {
                channel: "unrelated_channel",
                visibleUntil: 2000,
              },
              {
                channel: "existing_channel",
                visibleUntil: 3000,
              },
            ],
          },
        });

        const result = visibility.hide({
          channel: "existing_channel",
          delayMs: 500,
        });

        expect(result).toEqual({
          commands: [
            {
              channel: "unrelated_channel",
              visibleUntil: 2000,
            },
            {
              channel: "existing_channel",
              visibleUntil: 1500,
            },
          ],
        });
      });
    });

    describe("when channel currently isn't visible", () => {
      it("does not update the existing command", () => {
        const visibility = new UIVisibility({
          currentTime: 1000,
          state: {
            commands: [
              {
                channel: "unrelated_channel",
                visibleUntil: 2000,
              },
              {
                channel: "existing_channel",
                visibleUntil: 700,
              },
            ],
          },
        });

        const result = visibility.hide({
          channel: "existing_channel",
          delayMs: 500,
        });

        expect(result).toEqual({
          commands: [
            {
              channel: "unrelated_channel",
              visibleUntil: 2000,
            },
            {
              channel: "existing_channel",
              visibleUntil: 700,
            },
          ],
        });
      });
    });
  });
});

describe("#nextVisibilityChange", () => {
  describe("when visibility will change", () => {
    it("returns the remaining time until visibility changes", () => {
      const visibility = new UIVisibility({
        currentTime: 1000,
        state: {
          commands: [
            { channel: "a", visibleUntil: 4000 },
            { channel: "b", visibleUntil: 3500 },
          ],
        },
      });

      const result = visibility.nextVisibilityChange;

      expect(result).toEqual(3000);
    });
  });

  describe("when visibility will not change", () => {
    describe("will remain hidden", () => {
      it("returns null", () => {
        const visibility = new UIVisibility({
          currentTime: 1000,
          state: {
            commands: [
              { channel: "a", visibleUntil: 400 },
              { channel: "b", visibleUntil: 800 },
            ],
          },
        });

        const result = visibility.nextVisibilityChange;

        expect(result).toEqual(null);
      });
    });

    describe("will remain visible", () => {
      const forever = Number.MAX_SAFE_INTEGER;
      const visibility = new UIVisibility({
        currentTime: 1000,
        state: {
          commands: [
            { channel: "a", visibleUntil: 1700 },
            { channel: "b", visibleUntil: forever },
          ],
        },
      });

      const result = visibility.nextVisibilityChange;

      expect(result).toEqual(null);
    });
  });
});
