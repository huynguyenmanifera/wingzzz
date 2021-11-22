import * as React from "react";
import * as _ from "lodash";
import screenfull, { Screenfull } from "screenfull";
import Book, { BookType } from "./Book";
import BottomToolbar from "./animated_reader_controls/BottomToolbar";
import Loader from "react-loader-spinner";
import { isIOS, isMobileOnly } from "react-device-detect";
import { Howl } from "howler";

function getOrientation() {
  if (window.orientation !== undefined) {
    return window.orientation == 90 || window.orientation == -90
      ? "landscape"
      : "portrait";
  }

  return window.innerHeight > window.innerWidth ? "portrait" : "landscape";
}

interface AnimatedFlipReaderProps {
  audioFileURL: string;
  initialPage: number;
  initialAudio?: number;
  book: Book;

  onFinish: (currentPage: number) => void;
  onNavigate: (currentPage: number) => void;
}

enum LastPageFlipHandler {
  "book",
  "slide",
  "page_click",
}

enum FlipEventType {
  "next",
  "prev",
  "slide",
  "restart",
  "user_fold",
  "flipping",
}

interface AnimatedFlipReaderState {
  currentPage: number;
  fullscreen: boolean;
  book: Book;
  coverHeight: number;
  coverWidth: number;
  loaded: boolean;
  flipEvent: FlipEventType;
  lastPageFlipHandler: LastPageFlipHandler;
  loadedPages: Array<number>;
  orientation: string;
  playing: boolean;
  totalDuration?: number;
  currentTime?: number;
}

export default class AudioOnlyReader extends React.PureComponent<
  AnimatedFlipReaderProps,
  AnimatedFlipReaderState
> {
  private container: React.RefObject<HTMLDivElement>;
  private sound?: Howl;
  private timer?: number;
  private audioSession?: number;

  constructor(props: AnimatedFlipReaderProps) {
    super(props);
    this.container = React.createRef();

    if (this.canPlayAudio) {
      this.sound = new Howl({
        src: [this.props.audioFileURL],
      });

      this.sound.seek(this.props.initialAudio || 0);
    }

    this.state = {
      currentPage:
        props.initialPage === 1 ||
        _.range(
          this.props.book.totalPages - 4,
          this.props.book.totalPages,
          1
        ).includes(this.props.initialPage)
          ? 0
          : props.initialPage,
      fullscreen: false,
      book: props.book,
      coverHeight: 0,
      coverWidth: 0,
      loaded: this.sound?.state() === "loaded",
      flipEvent: FlipEventType.restart,
      lastPageFlipHandler: LastPageFlipHandler.book,
      loadedPages: [],
      orientation: getOrientation(),
      playing: false,
      currentTime: this.props.initialAudio || 0,
      totalDuration: this.sound?.duration(),
    };

    this.onKeyDown = this.onKeyDown.bind(this);
    this.toggleFullscreen = this.toggleFullscreen.bind(this);
    this.onFlip = this.onFlip.bind(this);
    this.onFinish = this.onFinish.bind(this);
    this.restart = this.restart.bind(this);
    this.nextPageAnim = this.nextPageAnim.bind(this);
    this.prevPageAnim = this.prevPageAnim.bind(this);
    this.slideTo = this.slideTo.bind(this);
    this.onChangeOrientation = this.onChangeOrientation.bind(this);
  }

  componentDidMount() {
    window.addEventListener("keydown", this.onKeyDown.bind(this), false);
    window.addEventListener("orientationchange", this.onChangeOrientation);

    ["play", "pause", "stop", "end"].forEach((eventName) => {
      this.sound?.on(eventName, this.onAudioStatusChanged);
    });

    ["pause", "stop", "end"].forEach((eventName) => {
      this.sound?.on(eventName, this.onStop);
    });

    ["seek", "stop"].forEach((eventName) => {
      this.sound?.on(eventName, this.onHandleSeek);
    });

    this.sound?.once("load", this.onLoadSound);
    this.sound?.on("end", this.onEnd);

    if (screenfull.isEnabled) {
      (screenfull as Screenfull).on(
        "change",
        this.onScreenfullChange.bind(this)
      );
    }

    // As full screen doesn't work on iPhone at least hide the browser
    if (isIOS && isMobileOnly) {
      window.scrollTo(0, 1);
    }
  }

  componentDidUpdate(
    prevProps: AnimatedFlipReaderProps,
    prevState: AnimatedFlipReaderState
  ) {
    if (prevState.currentPage != this.state.currentPage) {
      this.props.onNavigate(this.state.currentPage);
    }
  }

  componentWillUnmount() {
    if (screenfull.isEnabled) {
      screenfull.off("change", this.onScreenfullChange);
    }
    window.removeEventListener("keydown", this.onKeyDown, false);
    window.removeEventListener("orientationchange", this.onChangeOrientation);

    this.sound?.stop();

    ["play", "pause", "stop", "end"].forEach((eventName) => {
      this.sound?.off(eventName, this.onAudioStatusChanged);
    });

    ["pause", "stop", "end"].forEach((eventName) => {
      this.sound?.off(eventName, this.onStop);
    });

    ["seek", "stop"].forEach((eventName) => {
      this.sound?.off(eventName, this.onHandleSeek);
    });

    this.sound?.off("end", this.onEnd);
  }

  onEnd = () => {
    this.setState({
      currentTime: this.state.totalDuration,
    });

    this.props.onNavigate(this.state.totalDuration || 0);
  };

  onLoadSound = () => {
    this.setState({
      loaded: true,
      totalDuration: this.sound?.duration(),
    });
  };

  onAudioStatusChanged = () => {
    this.setState((state) => {
      return { ...state, playing: this.sound?.playing() || false };
    });
  };

  onPlaying = () => {
    this.timer = window.setInterval(() => {
      this.setState({
        currentTime: this.currentAudioTime,
      });
    }, 250);

    if (!this.audioOnly) {
      return;
    }

    this.audioSession = window.setInterval(() => {
      this.props.onNavigate(Math.floor(this.sound?.seek() || 0));
    }, 3000);
  };

  onStop = () => {
    clearInterval(this.timer);

    if (!this.audioOnly) {
      return;
    }

    clearInterval(this.audioSession);
  };

  onPlay = () => {
    if (this.sound?.playing()) {
      this.sound?.pause();
      this.onStop();
    } else {
      this.sound?.play();
      this.onPlaying();
    }
  };

  onSeek = (num: number) => {
    this.sound?.seek(num);
  };

  onHandleSeek = () => {
    this.setState({
      currentTime: this.currentAudioTime,
    });
  };

  toggleFullscreen() {
    if (!screenfull.isEnabled) return;

    if (this.state.fullscreen) {
      (screenfull as Screenfull).exit();
    } else {
      this.container.current &&
        (screenfull as Screenfull).request(this.container.current);
    }
  }

  onChangeOrientation(e: any) {
    const orientation = getOrientation();
    this.setState({ orientation });
  }

  onScreenfullChange() {
    this.setState({
      fullscreen: (screenfull as Screenfull).isFullscreen,
    });
  }

  onFinish() {
    this.setState({
      currentPage: 0,
    });
    this.props.onFinish(0);
  }

  onKeyDown(event: KeyboardEvent) {
    switch (event.code) {
      case "ArrowRight":
        this.nextPageAnim();
        return;
      case "Space":
      case "ArrowLeft":
        this.prevPageAnim();
        return;
    }
  }

  onFlip(e: any) {}

  slideTo(num: number) {}

  nextPageAnim() {}

  prevPageAnim() {}

  restart() {
    this.sound?.stop();

    this.props.onNavigate(0);
  }

  private get canPlayAudio(): boolean {
    return (
      !!this.props.audioFileURL && this.props.book.type !== BookType.Regular
    );
  }

  private get audioOnly(): boolean {
    return this.props.book.type === BookType.AudioOnly;
  }

  private get currentAudioTime(): number {
    return Math.floor(this.sound?.seek() || 0);
  }

  render() {
    return (
      <div className={"fbook-wrapper"} ref={this.container}>
        {!this.state.loaded && (
          <div style={{ width: "70px", height: "70px", margin: "0 auto" }}>
            <Loader type="Watch" color="#19c2f2" height={100} width={100} />
          </div>
        )}
        {this.state.loaded && (
          <div className="w-screen h-auto relative">
            <img
              className={"mx-auto h-screen"}
              src={this.props.book.coverURL}
              alt="book-cover"
            />
            <BottomToolbar
              currentPage={this.state.currentPage}
              totalPages={this.props.book.totalPages}
              restart={this.restart}
              sliderFlip={this.slideTo}
              finish={this.onFinish}
              fullscreen={
                (this.toggleFullscreen = this.toggleFullscreen.bind(this))
              }
              isFullscreen={this.state.fullscreen}
              canPlayAudio={this.canPlayAudio}
              playing={this.state.playing}
              onPlay={this.onPlay}
              audioOnly={this.audioOnly}
              sound={this.sound}
              totalDuration={this.state.totalDuration}
              currentTime={this.state.currentTime}
              onSeek={this.onSeek}
            />
          </div>
        )}
      </div>
    );
  }
}
