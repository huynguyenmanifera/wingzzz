import * as React from "react";
import classNames from "classnames";
import I18n, { l } from "i18n-js";
import * as _ from "lodash";
import { Progress } from "../services/progress";
import Icon from "../../ui/Icon";

interface FinishButtonProps {
  menuVisible: boolean;
  progress: Progress;
  onMouseEnter: () => void;
  onMouseLeave: () => void;
  onMouseMove: () => void;
  onClick: () => void;
}

const VISIBILITY = {
  // These constants are used to heuristically determine
  // whether the user is "near the end" of the book, and
  // thus if the finish button must be shown or not.

  // Ratio of book that must be read must be at least:
  PROGRESS_RATIO_THRESHOLD: 0.8,

  // Remaining renditions must be equal or less than:
  REMAINING_RENDITIONS_THRESHOLD: 2,
};

export default class FinishButton extends React.PureComponent<FinishButtonProps> {
  get visible() {
    return this.props.menuVisible && this.active;
  }

  get active() {
    const currentRendition = this.props.progress.currentRendition;
    const totalRenditions = this.props.progress.totalRenditions;
    const renditionsRemaining = totalRenditions - currentRendition;
    const progressRatio = currentRendition / totalRenditions;

    return (
      renditionsRemaining <= VISIBILITY.REMAINING_RENDITIONS_THRESHOLD &&
      progressRatio >= VISIBILITY.PROGRESS_RATIO_THRESHOLD
    );
  }

  render() {
    return (
      <div className={classNames("h-full", "flex", "items-center")}>
        <button
          onClick={this.props.onClick}
          onMouseEnter={this.props.onMouseEnter}
          onMouseLeave={this.props.onMouseLeave}
          onMouseMove={this.props.onMouseMove}
          className={classNames(
            this.active ? "opacity-100" : "opacity-0",
            "transition-opacity",
            "duration-300",

            this.active ? "pointer-events-auto" : "pointer-events-none",
            "mx-6",
            "btn",
            "btn-transparent",
            "btn-border",
            "btn-with-icon"
          )}
          style={{
            cursor: this.visible ? "pointer" : "inherit",
          }}
        >
          <Icon type="checkmark" />
          <span>{_.upperFirst(I18n.translate("finish"))}</span>
        </button>
      </div>
    );
  }
}
