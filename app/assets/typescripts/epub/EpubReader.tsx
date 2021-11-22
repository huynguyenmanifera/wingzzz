import * as React from "react";
import EpubRenditions from "./EpubRenditions";
import * as _ from "lodash";
import {
  next,
  previous,
  last,
  first,
  NavState,
} from "./services/navigationBehavior";
import ReaderControls from "./reader_controls/ReaderControls";
import screenfull, { Screenfull } from "screenfull";
import { progress, Progress } from "./services/progress";
import classNames from "classnames";
import Book from "./Book";

interface EpubReaderProps {
  epubFileURL: string;
  stylesheetURL: string;
  initialPage: number;
  backURL: string;
  book: Book;

  onFinish: (currentPage: number) => void;
  onNavigate: (currentPage: number) => void;
}

interface EpubReaderState {
  currentPage: number;
  showCursor: boolean;
  fullscreen: boolean;
}

const idleTimeCursorHideMs = 1000;

export default class EpubReader extends React.Component<
  EpubReaderProps,
  EpubReaderState
> {
  private container: React.RefObject<HTMLDivElement>;
  private cursorHideTimeout: number | null = null;

  constructor(props: EpubReaderProps) {
    super(props);

    this.container = React.createRef();

    this.state = {
      currentPage: props.initialPage,
      fullscreen: false,
      showCursor: true,
    };

    this.onKeyDown = this.onKeyDown.bind(this);
  }

  onKeyDown(event: KeyboardEvent) {
    switch (event.code) {
      case "ArrowLeft":
        this.navigatePreviousPage();
        return;

      case "Space":
      case "ArrowRight":
        this.navigateNextPage();
        return;
    }
  }

  onScreenfullChange() {
    this.setState((prevState) => {
      return {
        ...prevState,
        fullscreen: (screenfull as Screenfull).isFullscreen,
      };
    });
  }

  componentDidMount() {
    if (screenfull.isEnabled) {
      screenfull.on("change", this.onScreenfullChange.bind(this));
    }

    window.addEventListener("keydown", this.onKeyDown.bind(this), false);
    window.addEventListener("mousemove", this.mouseActivity.bind(this), false);
    window.addEventListener("mousedown", this.mouseActivity.bind(this), false);
  }

  componentDidUpdate(prevProps: EpubReaderProps, prevState: EpubReaderState) {
    if (prevState.currentPage !== this.state.currentPage) {
      this.props.onNavigate(this.state.currentPage);
    }
  }

  componentWillUnmount() {
    if (screenfull.isEnabled) {
      screenfull.off("change", this.onScreenfullChange);
    }

    window.removeEventListener("keydown", this.onKeyDown, false);
    window.removeEventListener("mousemove", this.mouseActivity, false);
    window.removeEventListener("mousedown", this.mouseActivity, false);
  }

  navigatePreviousPage() {
    this.setState((state) => {
      const newState = previous(this.navState);

      return {
        ...state,
        ...newState,
      };
    });
  }

  navigateNextPage() {
    this.setState((state) => {
      const newState = next(this.navState);

      return {
        ...state,
        ...newState,
      };
    });
  }

  toggleFullscreen() {
    if (!screenfull.isEnabled) return;

    this.state.fullscreen
      ? (screenfull as Screenfull).exit()
      : this.container.current &&
        (screenfull as Screenfull).request(this.container.current);
  }

  onFinish() {
    this.setState((state) => {
      const newState = last(this.navState.book);
      const waitForTransition = state.currentPage != newState.currentPage;

      setTimeout(
        () => {
          this.props.onFinish(newState.currentPage);
        },
        waitForTransition ? 1000 : 0
      );

      return {
        ...state,
        ...newState,
      };
    });
  }

  onRestart() {
    this.setState((state) => {
      const newState = first(this.navState.book);

      return {
        ...state,
        ...newState,
      };
    });
  }

  get canNavigatePrevious(): boolean {
    return this.state.currentPage != previous(this.navState).currentPage;
  }

  get canNavigateNext(): boolean {
    return this.state.currentPage != next(this.navState).currentPage;
  }

  throttledMouseActivity = _.throttle(() => {
    if (this.cursorHideTimeout) {
      clearInterval(this.cursorHideTimeout);
    }

    this.setState((prevState) => {
      if (!prevState.showCursor) {
        return {
          ...prevState,
          showCursor: true,
        };
      }
      return prevState;
    });

    this.cursorHideTimeout = window.setTimeout(() => {
      this.setState((prevState) => {
        return {
          ...prevState,
          showCursor: false,
        };
      });
    }, idleTimeCursorHideMs);
  }, 500);

  mouseActivity() {
    this.throttledMouseActivity();
  }

  private get navState(): NavState {
    return {
      book: this.props.book,
      currentPage: this.state.currentPage,
    };
  }

  private get progress(): Progress {
    return progress(this.navState);
  }

  render() {
    return (
      <div
        className={classNames(
          "w-screen",
          "h-full",
          "relative",
          "bg-wz-gray-700",
          "select-none"
        )}
        style={{
          cursor: !this.state.showCursor ? "none" : "default",
        }}
        ref={this.container}
      >
        <EpubRenditions
          book={this.props.book}
          stylesheetURL={this.props.stylesheetURL}
          currentPage={this.state.currentPage}
        />
        <ReaderControls
          canNavigatePrevious={this.canNavigatePrevious}
          onNavigatePrevious={this.navigatePreviousPage.bind(this)}
          canNavigateNext={this.canNavigateNext}
          onNavigateNext={this.navigateNextPage.bind(this)}
          backURL={this.props.backURL}
          fullscreen={this.state.fullscreen}
          onFullscreenToggle={this.toggleFullscreen.bind(this)}
          progress={this.progress}
          onFinish={this.onFinish.bind(this)}
          onRestart={this.onRestart.bind(this)}
        />
      </div>
    );
  }
}
