import * as React from "react";
import classNames from "classnames";
import { ReaderControlsProps } from "./ReaderControls";
import FullscreenButton from "./FullscreenButton";
import screenfull from "screenfull";
import ProgressBar from "./ProgressBar";
import FinishButton from "./FinishButton";
import RestartButton from "./RestartButton";

interface BottomControlsProps extends ReaderControlsProps {
  uiElementEnter: () => void;
  uiElementMouseLeave: () => void;
  uiElementMouseMove: () => void;
  visible: boolean;
}

export default class BottomControls extends React.PureComponent<BottomControlsProps> {
  render() {
    return (
      <div
        className={classNames("absolute", "left-0", "right-0", "bottom-0")}
        style={{
          height: "7rem",
        }}
      >
        {screenfull.isEnabled && (
          <FullscreenButton
            onMouseEnter={this.props.uiElementEnter}
            onMouseLeave={this.props.uiElementMouseLeave}
            onMouseMove={this.props.uiElementMouseMove}
            onFullscreenToggle={this.props.onFullscreenToggle}
            fullscreen={this.props.fullscreen}
            visible={this.props.visible}
          />
        )}
        <div
          style={{
            width: "80%",
            cursor: this.props.visible ? "default" : "inherit",
          }}
          className={classNames(
            "h-full",
            "left-0",
            "right-0",
            "mx-auto",
            "text-center",
            "flex",
            "items-center"
          )}
        >
          <div className={classNames("text-right")} style={{ width: "30rem" }}>
            <div className={classNames("inline-block")}>
              <RestartButton
                menuVisible={this.props.visible}
                onMouseEnter={this.props.uiElementEnter}
                onMouseLeave={this.props.uiElementMouseLeave}
                onMouseMove={this.props.uiElementMouseMove}
                onClick={this.props.onRestart}
                progress={this.props.progress}
              />
            </div>
          </div>
          <ProgressBar
            progress={this.props.progress}
            onMouseEnter={this.props.uiElementEnter}
            onMouseLeave={this.props.uiElementMouseLeave}
            onMouseMove={this.props.uiElementMouseMove}
          />
          <div className={classNames("text-left")} style={{ width: "30rem" }}>
            <FinishButton
              onMouseEnter={this.props.uiElementEnter}
              onMouseLeave={this.props.uiElementMouseLeave}
              onMouseMove={this.props.uiElementMouseMove}
              onClick={this.props.onFinish}
              progress={this.props.progress}
              menuVisible={this.props.visible}
            />
          </div>
        </div>
      </div>
    );
  }
}
