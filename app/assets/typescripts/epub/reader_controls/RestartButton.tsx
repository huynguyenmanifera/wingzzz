import * as React from "react";
import * as _ from "lodash";
import Icon from "../../ui/Icon";
import classNames from "classnames";
import { Progress } from "../services/progress";

interface RestartButtonProps {
  menuVisible: boolean;
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
  onClick: () => void;
  progress: Progress;
}

export default class RestartButton extends React.PureComponent<RestartButtonProps> {
  get active() {
    return this.props.progress.currentRendition > 1;
  }

  render() {
    return (
      <div
        onMouseEnter={this.props.onMouseEnter}
        onMouseLeave={this.props.onMouseLeave}
        onMouseMove={this.props.onMouseMove}
        onClick={this.props.onClick}
        className={classNames(
          this.active ? "opacity-100" : "opacity-0",
          "transition-opacity",
          "duration-300",
          this.active ? "pointer-events-auto" : "pointer-events-none",
          "text-wz-white-trn-700",
          "hover:text-wz-white",
          "cursor-pointer",
          "flex",
          "items-center",
          "p-5",
          "mx-2"
        )}
        data-action="restart"
        style={{
          cursor: this.props.menuVisible ? "pointer" : "inherit",
        }}
      >
        <Icon type="restart" />
      </div>
    );
  }
}
