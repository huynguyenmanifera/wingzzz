export const showTimeString = (currentTime: number, totalDuration: number) =>
  `${calculateCurrentValue(currentTime)} / ${calculateTotalValue(
    totalDuration
  )}`;

export const calculateTotalValue = (length: number) => {
  const minutes = Math.floor(length / 60);
  const secondsInt: number = length - minutes * 60;

  let secondsStr = secondsInt.toFixed();
  if (secondsInt < 10) {
    secondsStr = "0" + secondsInt.toFixed();
  }

  const seconds = secondsStr.substr(0, 2);
  return (minutes < 10 ? "0" + minutes : minutes) + ":" + seconds;
};

export const calculateCurrentValue = (currentTime: number) => {
  const currentMinute = (currentTime / 60) % 60;
  const currentSeconds = currentTime % 60;

  return `${
    currentMinute < 10
      ? "0" + Math.floor(currentMinute)
      : Math.floor(currentMinute)
  }:${
    currentSeconds < 10
      ? "0" + currentSeconds.toFixed()
      : currentSeconds.toFixed()
  }`;
};
