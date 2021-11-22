import * as React from "react";
import classNames from "classnames";
import * as _ from "lodash";
import * as MenuGradient from "./MenuGradient";
import * as MenuTriggerArea from "./MenuTriggerArea";
import ExitButton from "./ExitButton";
import PageNavigationAreas from "./PageNavigationAreas";

import {
  VisibilityState,
  UIVisibility,
} from "../helpers/ui_visibility/UIVisibility";
import { UIVisibilityConnector } from "../helpers/ui_visibility/UIVisibilityConnector";
import BottomControls from "./BottomControls";
import { Progress } from "../services/progress";

export interface ReaderControlsProps {
  canNavigatePrevious: boolean;
  onNavigatePrevious: () => void;
  canNavigateNext: boolean;
  onNavigateNext: () => void;
  onFinish: () => void;
  onRestart: () => void;

  backURL: string;
  fullscreen: boolean;
  onFullscreenToggle: () => void;
  progress: Progress;
}

interface ReaderControlsState {
  menuVisibility: VisibilityState;
}

export default class ReaderControls extends React.Component<
  ReaderControlsProps,
  ReaderControlsState
> {
  private menuVisibility: UIVisibilityConnector;

  constructor(props: ReaderControlsProps) {
    super(props);

    this.state = {
      menuVisibility: UIVisibility.initialState,
    };

    this.menuVisibility = this.createVisibility();
  }

  private createVisibility() {
    return new UIVisibilityConnector({
      getState: () => {
        return this.state.menuVisibility;
      },
      setState: (callback) => {
        this.setState((prevState) => {
          return {
            ...prevState,
            menuVisibility: callback(prevState.menuVisibility),
          };
        });
      },
      forceUpdate: () => {
        this.forceUpdate();
      },
    });
  }

  componentDidMount() {
    this.menuVisibility.show({ ms: 2000 });
  }

  componentWillUnmount() {
    this.menuVisibility.destroy();
  }

  globalClick() {
    this.menuVisibility.show({ ms: 4000 });
  }

  triggerAreaMouseEnter() {
    this.menuVisibility.show({ channel: "trigger_area", ms: 1500 });
  }

  triggerAreaMouseLeave() {
    this.throttledUIElementMouseMove.cancel();
    this.throttledTriggerAreaMouseMove.cancel();
    this.menuVisibility.hide({ channel: "trigger_area", delayMs: 800 });
  }

  throttledTriggerAreaMouseMove = _.throttle(() => {
    this.menuVisibility.show({ channel: "trigger_area", ms: 1500 });
  }, 500);

  triggerAreaMouseMove() {
    this.throttledTriggerAreaMouseMove();
  }

  uiElementEnter() {
    this.menuVisibility.show({ channel: "ui_element", ms: 10000 });
  }

  throttledUIElementMouseMove = _.throttle(() => {
    this.menuVisibility.show({ channel: "ui_element", ms: 10000 });
  }, 500);

  uiElementMouseMove() {
    this.throttledUIElementMouseMove();
  }

  uiElementMouseLeave() {
    this.throttledUIElementMouseMove.cancel();
    this.menuVisibility.hide({ channel: "ui_element", delayMs: 1500 });
  }

  render() {
    return (
      <>
        <div
          className={classNames("w-full", "h-full", "absolute")}
          onClick={this.globalClick.bind(this)}
        ></div>
        <PageNavigationAreas {...this.props} />
        <div
          className={classNames(
            this.menuVisibility.isVisible ? "opacity-100" : "opacity-0",
            "h-full",
            "w-full",
            "absolute",
            "pointer-events-none"
          )}
          style={{
            transition: this.menuVisibility.isVisible
              ? "opacity 0.7s"
              : undefined,
          }}
        >
          <MenuGradient.default location={MenuGradient.Location.Top} />
          <MenuGradient.default location={MenuGradient.Location.Bottom} />

          <MenuTriggerArea.default
            location={MenuTriggerArea.Location.Top}
            onMouseEnter={this.triggerAreaMouseEnter.bind(this)}
            onMouseMove={this.triggerAreaMouseMove.bind(this)}
            onMouseLeave={this.triggerAreaMouseLeave.bind(this)}
          />

          <MenuTriggerArea.default
            location={MenuTriggerArea.Location.Bottom}
            onMouseEnter={this.triggerAreaMouseEnter.bind(this)}
            onMouseMove={this.triggerAreaMouseMove.bind(this)}
            onMouseLeave={this.triggerAreaMouseLeave.bind(this)}
          />

          <ExitButton
            onMouseEnter={this.uiElementEnter.bind(this)}
            onMouseLeave={this.uiElementMouseLeave.bind(this)}
            onMouseMove={this.uiElementMouseMove.bind(this)}
            backURL={this.props.backURL}
            visible={this.menuVisibility.isVisible}
          />

          <BottomControls
            {...this.props}
            uiElementEnter={this.uiElementEnter.bind(this)}
            uiElementMouseLeave={this.uiElementMouseLeave.bind(this)}
            uiElementMouseMove={this.uiElementMouseMove.bind(this)}
            visible={this.menuVisibility.isVisible}
          />
        </div>
      </>
    );
  }
}
