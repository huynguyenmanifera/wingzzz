import * as React from "react";
import SVG from "react-inlinesvg";
import classNames from "classnames";
import assets from "../services/assets";
import Icon, { IconSize, IconType } from "../../ui/Icon";

export enum ButtonType {
  Previous = "previous",
  Next = "next",
}

interface PageNavigationButtonProps {
  buttonType: ButtonType;
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
}

const buttonWidthEm = 10;

export default class PageNavigationButton extends React.PureComponent<PageNavigationButtonProps> {
  render() {
    return (
      <div
        onMouseEnter={this.props.onMouseEnter}
        onMouseLeave={this.props.onMouseLeave}
        onMouseMove={this.props.onMouseMove}
        className={classNames(
          "w-64",
          "h-64",
          "absolute",
          "top-0",
          "bottom-0",
          "m-auto",
          "rounded-full",
          "inline-block",
          "text-wz-white",
          "fill-current"
        )}
        style={{
          background: "rgba(0, 0, 0, 0.25)",
          width: `${buttonWidthEm}em`,
          height: `${buttonWidthEm}em`,
          left:
            this.props.buttonType === ButtonType.Previous
              ? `${-buttonWidthEm / 2}em`
              : undefined,
          right:
            this.props.buttonType === ButtonType.Next
              ? `${-buttonWidthEm / 2}em`
              : undefined,
        }}
      >
        <div
          className={classNames(
            "relative",
            "w-full",
            "h-full",
            "flex",
            this.props.buttonType === ButtonType.Next
              ? "justify-start"
              : "justify-end"
          )}
          style={{
            left: this.props.buttonType === ButtonType.Next ? "18%" : undefined,
            right:
              this.props.buttonType === ButtonType.Previous ? "18%" : undefined,
          }}
        >
          <div className={classNames("self-center")}>
            {(() => {
              switch (this.props.buttonType) {
                case ButtonType.Previous:
                  return <Icon size="large" type="page-back" />;

                case ButtonType.Next:
                  return <Icon size="large" type="page-forward" />;
              }
            })()}
          </div>
        </div>
      </div>
    );
  }
}
