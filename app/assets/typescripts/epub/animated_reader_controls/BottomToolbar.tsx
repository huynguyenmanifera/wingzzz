import * as React from "react";
import Icon from "../../ui/Icon";
import classNames from "classnames";
import I18n, { l } from "i18n-js";
import * as _ from "lodash";
import { isIOS, isMobileOnly } from "react-device-detect";
import { Howl } from "howler";
import ProgressSlider from "./ProgressSlider";
import { showTimeString } from "../services/audioProgress";

interface BottomToolbarProps {
  currentPage: number;
  totalPages: number;
  isFullscreen: boolean;
  canPlayAudio?: boolean;
  playing?: boolean;
  audioOnly?: boolean;
  sound?: Howl;
  currentTime: number;
  totalDuration: number;

  restart: () => void;
  sliderFlip: (num: number) => void;
  finish: () => void;
  fullscreen: () => void;
  onPlay?: () => void;
  onSeek?: (num: number) => void;
}

interface ToolBarState {
  slider: number;
  currentPageTarget?: number;
  visisbleMobile: any;
}

export default class BottomToolbar extends React.Component<
  BottomToolbarProps,
  ToolBarState
> {
  static defaultProps = {
    currentTime: 0,
    totalDuration: 1,
  };

  constructor(props: BottomToolbarProps) {
    super(props);

    this.state = {
      slider: 0,
      currentPageTarget: undefined,
      visisbleMobile: null,
    };

    this.sliderFlip = this.sliderFlip.bind(this);
    this.handleActivate = this.handleActivate.bind(this);
  }

  componentDidUpdate(prevProps: BottomToolbarProps, prevState: ToolBarState) {
    if (this.props.currentPage != prevProps.currentPage) {
      this.setState({ currentPageTarget: undefined });
    }
  }

  sliderFlip(num: number) {
    this.props.sliderFlip(num);
    this.setState({ currentPageTarget: num });
  }

  canUseFullscreen() {
    return !(isMobileOnly && isIOS);
  }

  handleActivate(e: any) {
    clearTimeout(this.state.visisbleMobile);
    const visisbleMobile = setTimeout(
      () => this.setState({ visisbleMobile: null }),
      3000
    );
    this.setState({ visisbleMobile: visisbleMobile });
  }

  audioTime() {
    return showTimeString(this.props.currentTime, this.props.totalDuration);
  }

  isAudioEnd() {
    if (!this.props.canPlayAudio) {
      return false;
    }

    return (
      Math.floor(this.props.currentTime) ===
      Math.floor(this.props.totalDuration)
    );
  }

  render() {
    return (
      <div
        className={`fbook-bottom-toolbar ${
          this.state.visisbleMobile ? "visible-mobile" : ""
        }`}
        onTouchStart={this.handleActivate}
      >
        <div className="grid grid-cols-10 gap-4">
          <div className="col-span-1">
            <a href="/books" data-action="exit" className="inline-block">
              <Icon type="back" size="large" />
            </a>
          </div>
          <div
            className={classNames(
              this.props.canPlayAudio ? "col-span-1" : "col-span-2",
              "text-right"
            )}
          >
            {(this.props.currentPage > 2 || this.props.audioOnly) && (
              <div
                className="inline-block mr-8 cursor-pointer"
                onClick={(e) => {
                  e.stopPropagation();
                  this.props.restart();
                }}
                data-action={"restart"}
              >
                <Icon type="restart" />
              </div>
            )}
          </div>
          {this.props.canPlayAudio && (
            <div className="col-span-1 text-right">
              <div
                className="inline-block mr-8 cursor-pointer"
                onClick={this.props.onPlay}
                data-action={"play"}
              >
                <Icon type={this.props.playing ? "pause" : "play"} />
              </div>
            </div>
          )}
          <div className="col-span-4">
            <div className="mt-4">
              {this.props.audioOnly ? (
                !!this.props.totalDuration && (
                  <ProgressSlider
                    max={Math.floor(this.props.totalDuration)}
                    onAfterChange={this.props.onSeek}
                    value={Math.floor(this.props.currentTime)}
                  />
                )
              ) : (
                <ProgressSlider
                  max={this.props.totalPages - 1}
                  step={1}
                  onAfterChange={this.sliderFlip}
                  value={this.state.currentPageTarget || this.props.currentPage}
                />
              )}
            </div>
          </div>
          <div className="col-span-2 finish">
            {(this.isAudioEnd() ||
              this.props.currentPage >= this.props.totalPages - 2) && (
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  this.props.finish();
                }}
                className={classNames(
                  "transition-opacity",
                  "duration-300",
                  "mx-6",
                  "btn",
                  "btn-transparent",
                  "btn-border",
                  "btn-with-icon"
                )}
              >
                <Icon type="checkmark" />
                <span>{_.upperFirst(I18n.translate("finish"))}</span>
              </button>
            )}
          </div>
          {this.canUseFullscreen() && (
            <div className="full-screen-button">
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  this.props.fullscreen();
                }}
                className="focus:outline-none hover:text-wz-white text-wz-white-trn-700"
                data-action={
                  this.props.isFullscreen
                    ? "exit-fullscreen"
                    : "enter-fullscreen"
                }
              >
                <Icon
                  type={
                    this.props.isFullscreen ? "exit-fullscreen" : "fullscreen"
                  }
                  size="large"
                />
              </button>
            </div>
          )}
          {this.props.audioOnly ? (
            !!this.props.totalDuration && (
              <div className="col-span-10 pagenum">{this.audioTime()}</div>
            )
          ) : (
            <div className="col-span-10 pagenum">
              {this.props.currentPage} of {this.props.totalPages - 1}
            </div>
          )}
        </div>
      </div>
    );
  }
}
