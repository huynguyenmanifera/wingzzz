import {
  ShowConfig,
  HideConfig,
  VisibilityState,
  UIVisibility,
} from "./UIVisibility";

interface VisibilityConnectorProps {
  getState: () => VisibilityState;
  setState: (callback: (prevState: VisibilityState) => VisibilityState) => void;
  forceUpdate: () => void;
}

export class UIVisibilityConnector {
  private props: VisibilityConnectorProps;
  private forceUpdateTimeout: number | null = null;

  constructor(props: VisibilityConnectorProps) {
    this.props = props;
  }

  show(config?: ShowConfig) {
    return this.stateChange((prevState, currentTime) => {
      return new UIVisibility({
        state: prevState,
        currentTime,
      }).show(config);
    });
  }

  hide(config?: HideConfig) {
    return this.stateChange((prevState, currentTime) => {
      return new UIVisibility({
        state: prevState,
        currentTime,
      }).hide(config);
    });
  }

  destroy() {
    this.clearForceUpdateTimeout();
  }

  get isVisible() {
    return new UIVisibility({
      state: this.props.getState(),
      currentTime: Date.now(),
    }).isVisible;
  }

  private stateChange(
    callback: (
      prevState: VisibilityState,
      currentTime: number
    ) => VisibilityState
  ) {
    this.props.setState((prevState) => {
      const currentTime = Date.now();
      const newState = callback(prevState, currentTime);
      const nextChange = new UIVisibility({
        state: newState,
        currentTime,
      }).nextVisibilityChange;

      this.forceUpdateAfter(nextChange);

      return newState;
    });
  }

  private forceUpdateAfter(ms: number | null) {
    this.clearForceUpdateTimeout();

    if (ms === null) {
      return;
    }

    this.forceUpdateTimeout = window.setTimeout(() => {
      this.props.forceUpdate();
    }, ms);
  }

  private clearForceUpdateTimeout() {
    if (this.forceUpdateTimeout) {
      clearInterval(this.forceUpdateTimeout);
    }
  }
}
