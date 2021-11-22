import * as React from "react";
import classNames from "classnames";

export enum Location {
  Top = "top",
  Bottom = "bottom",
}

interface MenuTriggerAreaProps {
  location: Location;
  onMouseEnter: () => void;
  onMouseMove: () => void;
  onMouseLeave: () => void;
}

export default class MenuTriggerArea extends React.PureComponent<MenuTriggerAreaProps> {
  render() {
    return (
      <div
        id={
          this.props.location === Location.Top
            ? "reader-navbar-top"
            : "reader-navbar-bottom"
        }
        onMouseEnter={this.props.onMouseEnter}
        onMouseMove={this.props.onMouseMove}
        onMouseLeave={this.props.onMouseLeave}
        className={classNames(
          "h-16",
          "absolute",
          this.props.location === Location.Top ? "top-0" : "bottom-0",
          "w-full",
          "pointer-events-auto"
        )}
      ></div>
    );
  }
}
