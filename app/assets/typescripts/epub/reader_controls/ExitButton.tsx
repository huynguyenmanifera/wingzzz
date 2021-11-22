import * as React from "react";
import classNames from "classnames";
import SVG from "react-inlinesvg";
import assets from "../services/assets";
import Icon from "../../ui/Icon";

interface ExitButtonProps {
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
  backURL: string;
  visible: boolean;
}

export default class ExitButton extends React.PureComponent<ExitButtonProps> {
  render() {
    return (
      <a
        data-action="exit"
        onMouseEnter={this.props.onMouseEnter}
        onMouseLeave={this.props.onMouseLeave}
        onMouseMove={this.props.onMouseMove}
        href={this.props.backURL}
        onClick={(e) => e.stopPropagation()}
        className={classNames(
          "pointer-events-auto",
          "absolute",
          "inline-block",
          "text-wz-white",
          "opacity-75",
          "hover:opacity-100",
          "fill-current",
          "pt-8",
          "pl-10",
          "pr-20",
          "pb-20"
        )}
        style={{
          cursor: this.props.visible ? "pointer" : "inherit",
        }}
      >
        <Icon type="back" size="large" />
      </a>
    );
  }
}
