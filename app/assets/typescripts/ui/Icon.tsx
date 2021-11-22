import * as React from "react";
import classNames from "classnames";
import SVG from "react-inlinesvg";

const icons = {
  back: require("images/icons/back.svg"),
  "exit-fullscreen": require("images/icons/exit-fullscreen.svg"),
  fullscreen: require("images/icons/fullscreen.svg"),
  "page-back": require("images/icons/page-back.svg"),
  "page-forward": require("images/icons/page-forward.svg"),
  checkmark: require("images/icons/checkmark.svg"),
  restart: require("images/icons/restart.svg"),
  play: require("images/icons/play.svg"),
  pause: require("images/icons/pause.svg"),
};

export type IconType =
  | "back"
  | "exit-fullscreen"
  | "fullscreen"
  | "page-back"
  | "page-forward"
  | "checkmark"
  | "play"
  | "pause"
  | "restart";

export type IconSize = "small" | "medium" | "large";

interface IconProps {
  size?: IconSize;
  type: IconType;
}

export default class Icon extends React.PureComponent<IconProps> {
  get size() {
    return this.props.size || "medium";
  }

  get sizeClass() {
    return `icon-${this.size}`;
  }

  get iconSrc() {
    return icons[this.props.type];
  }

  render() {
    return (
      <span className={classNames("icon", this.sizeClass)}>
        <SVG
          src={this.iconSrc}
          className={classNames("left-0", "top-0", "w-full", "h-full")}
        />
      </span>
    );
  }
}
