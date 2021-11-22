import * as React from "react";
import classNames from "classnames";
import SVG from "react-inlinesvg";
import assets from "../services/assets";
import Icon from "../../ui/Icon";

interface FullscreenButtonProps {
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
  onFullscreenToggle: () => void;
  fullscreen: boolean;
  visible: boolean;
}

export default class FullscreenButton extends React.PureComponent<FullscreenButtonProps> {
  render() {
    return (
      <button
        onMouseEnter={this.props.onMouseEnter}
        onMouseLeave={this.props.onMouseLeave}
        onMouseMove={this.props.onMouseMove}
        onClick={(e) => {
          e.stopPropagation();
          this.props.onFullscreenToggle();
        }}
        className={classNames(
          "pointer-events-auto",
          "fill-current",
          "hover:text-wz-white",
          "absolute",
          "right-0",
          "top-0",
          "bottom-0",
          "pr-10",
          "pl-20",
          "focus:outline-none",
          "text-wz-white-trn-700"
        )}
        style={{
          cursor: this.props.visible ? "pointer" : "inherit",
        }}
        data-action={
          this.props.fullscreen ? "exit-fullscreen" : "enter-fullscreen"
        }
      >
        <Icon
          type={this.props.fullscreen ? "exit-fullscreen" : "fullscreen"}
          size="large"
        />
      </button>
    );
  }
}
