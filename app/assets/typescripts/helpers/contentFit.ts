type Dimensions = { width: number; height: number };

const contentFit = ({
  content,
  container,
}: {
  content: Dimensions;
  container: Dimensions;
}): Dimensions | undefined => {
  if (
    content.width <= 0 ||
    content.height <= 0 ||
    container.width <= 0 ||
    container.height <= 0
  ) {
    throw new Error("Content and container must have positive dimensions");
  }

  if (contentAspectRatioIsWider({ content, container })) {
    return scaleToWidth({
      content,
      newWidth: container.width,
    });
  } else {
    return scaleToHeight({
      content,
      newHeight: container.height,
    });
  }
};

export default contentFit;

const contentAspectRatioIsWider = ({
  content,
  container,
}: {
  content: Dimensions;
  container: Dimensions;
}): boolean | Error => {
  return content.width / content.height > container.width / container.height;
};

const scaleToWidth = ({
  content,
  newWidth,
}: {
  content: Dimensions;
  newWidth: number;
}): Dimensions => {
  return {
    width: newWidth,
    height: content.height * (newWidth / content.width),
  };
};

const scaleToHeight = ({
  content,
  newHeight,
}: {
  content: Dimensions;
  newHeight: number;
}): Dimensions => {
  return {
    width: content.width * (newHeight / content.height),
    height: newHeight,
  };
};
