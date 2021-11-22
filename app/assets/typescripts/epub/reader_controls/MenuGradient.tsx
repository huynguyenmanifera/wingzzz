import * as React from "react";
import classNames from "classnames";

export enum Location {
  Top = "top",
  Bottom = "bottom",
}

const gradientTop =
  "linear-gradient(rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0) 100%)";
const gradientBottom =
  "linear-gradient(rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.5) 100%)";

interface MenuGradientProps {
  location: Location;
}

export default class MenuGradient extends React.PureComponent<MenuGradientProps> {
  render() {
    return (
      <div
        className={classNames(
          "w-full",
          "h-32",
          "absolute",
          this.props.location === Location.Top ? "top-0" : "bottom-0",
          "pointer-events-none"
        )}
        style={{
          backgroundImage:
            this.props.location === Location.Top ? gradientTop : gradientBottom,
        }}
      ></div>
    );
  }
}
