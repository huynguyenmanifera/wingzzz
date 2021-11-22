import * as React from "react";
import classNames from "classnames";
import { Progress, progressRatio } from "../services/progress";
import I18n from "i18n-js";

interface ProgressBarProps {
  progress: Progress;
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
}

export default class ProgressBar extends React.PureComponent<ProgressBarProps> {
  get progress() {
    return this.props.progress;
  }

  get currentRendition() {
    return this.progress.currentRendition;
  }

  get totalRenditions() {
    return this.progress.totalRenditions;
  }

  get progressPercentage() {
    return 100 * progressRatio(this.progress);
  }

  render() {
    return (
      <div
        onMouseEnter={this.props.onMouseEnter}
        onMouseLeave={this.props.onMouseLeave}
        onMouseMove={this.props.onMouseMove}
        className={classNames(
          "w-full",
          "h-16",
          "relative",
          "pointer-events-auto"
        )}
      >
        <div
          className={classNames(
            "w-full",
            "bg-wz-white-trn-300",
            "top-0",
            "bottom-0",
            "my-auto",
            "absolute",
            "rounded-full"
          )}
          style={{
            height: "0.5rem",
          }}
        >
          <div
            className={classNames(
              "h-full",
              "rounded-l-full",
              this.progressPercentage === 100 && "rounded-r-full",
              "bg-wz-white",
              "transition-width",
              "duration-500"
            )}
            style={{ width: `${this.progressPercentage}%` }}
          ></div>
        </div>
        <div
          className={classNames(
            "absolute",
            "bottom-0",
            "left-0",
            "right-0",
            "text-sm",
            "text-wz-white-trn-700"
          )}
        >
          {I18n.translate("book_progress", {
            current: this.currentRendition,
            total: this.totalRenditions,
          })}
        </div>
      </div>
    );
  }
}
