import * as React from "react";
import classNames from "classnames";
import * as _ from "lodash";
import {
  VisibilityState,
  UIVisibility,
} from "../helpers/ui_visibility/UIVisibility";
import { UIVisibilityConnector } from "../helpers/ui_visibility/UIVisibilityConnector";
import PageNavigationButton, { ButtonType } from "./NavigateButton";

export enum Type {
  Previous = "previous",
  Next = "next",
}

interface PageNavigationAreaProps {
  active: boolean;
  type: Type;
  onClick: () => void;
}

interface PageNavigationAreaState {
  visibility: VisibilityState;
}

const widthPercent = 35;
const heightPercent = 85;

export default class PageNavigationArea extends React.Component<
  PageNavigationAreaProps,
  PageNavigationAreaState
> {
  private visibility: UIVisibilityConnector;

  constructor(props: PageNavigationAreaProps) {
    super(props);

    this.state = {
      visibility: UIVisibility.initialState,
    };

    this.visibility = this.createVisibility();
  }

  private createVisibility() {
    return new UIVisibilityConnector({
      getState: () => {
        return this.state.visibility;
      },
      setState: (callback) => {
        this.setState((prevState) => {
          return {
            ...prevState,
            visibility: callback(prevState.visibility),
          };
        });
      },
      forceUpdate: () => {
        this.forceUpdate();
      },
    });
  }

  private get baseStyle(): React.CSSProperties {
    const widthPercent = 40;
    const heightPercent = 100;

    return {
      top: `${(100 - heightPercent) / 2}%`,
      width: `${widthPercent}%`,
      height: `${heightPercent}%`,
      position: "absolute",
    };
  }

  componentWillUnmount() {
    this.visibility.destroy();
  }

  areaMouseEnter() {
    this.visibility.show({ channel: "area", ms: 800 });
  }

  private areaMouseX: number | undefined;
  throttledAreaMouseMove = _.throttle((e: React.MouseEvent) => {
    if (!e.nativeEvent) {
      return;
    }

    const shouldShow = (() => {
      if (!this.areaMouseX) {
        return false;
      }

      const deltaX = e.nativeEvent.clientX - this.areaMouseX;

      if (this.props.type === Type.Previous) {
        return deltaX < 0;
      } else {
        return deltaX > 0;
      }
    })();

    this.areaMouseX = e.nativeEvent.clientX;

    if (shouldShow) {
      this.visibility.show({ channel: "area", ms: 800 });
    }
  }, 500);

  areaMouseMove(e: React.MouseEvent) {
    // If you want to access the event properties in an asynchronous way,
    // you should call event.persist() on the event, which will remove the
    // synthetic event from the pool and allow references to the event to be
    // retained by user code.
    //
    // We access the event in an asynchronous way, because we are throttling
    // the function.
    e.persist();

    this.throttledAreaMouseMove(e);
  }

  buttonMouseEnter() {
    this.visibility.show({ channel: "button", ms: 10000 });
  }

  throttledButtonMouseMove = _.throttle(() => {
    this.visibility.show({ channel: "button", ms: 10000 });
  }, 500);

  buttonMouseMove() {
    this.throttledButtonMouseMove();
  }

  buttonMouseLeave() {
    this.throttledButtonMouseMove.cancel();
    this.throttledAreaMouseMove.cancel();
    this.visibility.hide({ channel: "button" });
  }

  render() {
    return (
      <button
        onMouseMove={this.areaMouseMove.bind(this)}
        onMouseEnter={this.areaMouseEnter.bind(this)}
        style={{
          ...this.baseStyle,
          top: `${(100 - heightPercent) / 2}%`,
          width: `${widthPercent}%`,
          height: `${heightPercent}%`,
          position: "absolute",
          right: this.props.type === Type.Next ? 0 : undefined,
          left: this.props.type === Type.Previous ? 0 : undefined,
          overflow: "hidden",
          transition: this.visibility.isVisible ? "opacity 0.4s" : undefined,
          cursor: this.visibility.isVisible ? "pointer" : "inherit",
        }}
        className={classNames(
          { "cursor-pointer": this.visibility.isVisible },
          this.visibility.isVisible ? "opacity-100" : "opacity-0",
          "focus:outline-none"
        )}
        onClick={this.props.onClick}
      >
        <PageNavigationButton
          onMouseEnter={this.buttonMouseEnter.bind(this)}
          onMouseLeave={this.buttonMouseLeave.bind(this)}
          onMouseMove={this.buttonMouseMove.bind(this)}
          buttonType={
            this.props.type === Type.Previous
              ? ButtonType.Previous
              : ButtonType.Next
          }
        />
      </button>
    );
  }
}
