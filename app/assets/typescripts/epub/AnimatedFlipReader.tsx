import * as React from "react";
import * as _ from "lodash";
import { NavState } from "./services/navigationBehavior";
import screenfull, { Screenfull } from "screenfull";
import { progress, Progress } from "./services/progress";
import Book, { BookType } from "./Book";
import HTMLFlipBook from "react-pageflip";
import FlipControls from "./animated_reader_controls/FlipControls";
import BottomToolbar from "./animated_reader_controls/BottomToolbar";
import * as LazyPageLoader from "./services/lazyPageLoader";
import Loader from "react-loader-spinner";
import LazyPage from "./LazyPage";
import { isIOS, isMobileOnly, isTablet } from "react-device-detect";
import { TransformWrapper, TransformComponent } from "react-zoom-pan-pinch";
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
  epubFileURL: string;
  audioFileURL: string;
  initialPage: number;
  initialAudio?: number;
  book: Book;
  pageImages: Array<object>;
  epubDirectory: String;

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

interface ZoomableProps {
  children: JSX.Element;
  disabled: boolean;
  zoom?: number;
}

function Zoomable({ children, disabled }: ZoomableProps) {
  if (disabled) {
    // the fit-content prevents hard-cover-turns to glitch to the
    // top, the inner w-screen h-auto then make sure positioning
    // is correct again...
    return (
      <div style={{ width: "fit-content", height: "fit-content" }}>
        <div className="w-screen h-auto">{children}</div>
      </div>
    );
  }

  return (
    <TransformWrapper pan={{ paddingSize: 5 }}>
      <TransformComponent>
        <div className="w-screen h-auto">{children}</div>
      </TransformComponent>
    </TransformWrapper>
  );
}

interface AnimatedFlipReaderState {
  currentPage: number;
  fullscreen: boolean;
  book: Book;
  coverHeight: number;
  coverWidth: number;
  loaded: boolean;
  bookDb: Array<any>;
  flipEvent: FlipEventType;
  lastPageFlipHandler: LastPageFlipHandler;
  loadedPages: Array<number>;
  orientation: string;
  playing: boolean;
  totalDuration?: number;
  currentTime?: number;
}

export default class AnimatedFlipReader extends React.PureComponent<
  AnimatedFlipReaderProps,
  AnimatedFlipReaderState
> {
  private container: React.RefObject<HTMLDivElement>;
  private fbook: any;
  private sound?: Howl;
  private timer?: number;
  private audioSession?: number;

  constructor(props: AnimatedFlipReaderProps) {
    super(props);
    this.fbook = React.createRef();
    this.container = React.createRef();

    const bdb = this.props.pageImages.map((img: any, i: number) => {
      img["lazyRef"] = React.createRef();
      img["loaded"] = false;
      img["page"] = i;
      return img;
    });

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
      loaded: false,
      bookDb: bdb,
      flipEvent: FlipEventType.restart,
      lastPageFlipHandler: LastPageFlipHandler.book,
      loadedPages: [],
      orientation: getOrientation(),
      playing: false,
      currentTime: this.props.initialAudio || 0,
    };

    this.onKeyDown = this.onKeyDown.bind(this);
    this.toggleFullscreen = this.toggleFullscreen.bind(this);
    this.onFlip = this.onFlip.bind(this);
    this.onFinish = this.onFinish.bind(this);
    this.pageLoaded = this.pageLoaded.bind(this);
    this.restart = this.restart.bind(this);
    this.nextPageAnim = this.nextPageAnim.bind(this);
    this.prevPageAnim = this.prevPageAnim.bind(this);
    this.slideTo = this.slideTo.bind(this);
    this.onChangeOrientation = this.onChangeOrientation.bind(this);

    LazyPageLoader.imageLoader(
      this.state.bookDb[0],
      this.props.epubDirectory
    ).then((e: any) => {
      this.setState({
        coverWidth: e.width,
        coverHeight: e.height,
        loaded: true,
      });
      LazyPageLoader.lazyLoader(
        this.state.currentPage,
        FlipEventType.slide,
        this.state.bookDb,
        this.state.currentPage
      );
    });
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

    this.sound?.on("load", this.onLoadSound);

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
  }

  onLoadSound = () => {
    this.setState({
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
        currentTime: this.sound?.seek() || 0,
      });
    }, 250);

    if (!this.audioOnly) {
      return;
    }

    this.audioSession = window.setInterval(() => {
      this.props.onNavigate(this.sound?.seek() || 0);
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
      currentTime: this.sound?.seek() || 0,
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

  onFlip(e: any) {
    LazyPageLoader.lazyLoader(
      e.data,
      FlipEventType.user_fold,
      this.state.bookDb,
      this.state.currentPage
    );
    this.setState({
      lastPageFlipHandler: LastPageFlipHandler.page_click,
      currentPage: e.data,
    });
  }

  slideTo(num: number) {
    LazyPageLoader.lazyLoader(
      num,
      FlipEventType.slide,
      this.state.bookDb,
      this.state.currentPage
    );

    this.fbook.current.pageFlip().flip(num, "top");
  }

  nextPageAnim() {
    LazyPageLoader.lazyLoader(
      this.state.currentPage + 1,
      FlipEventType.next,
      this.state.bookDb,
      this.state.currentPage
    );
    this.fbook.current.pageFlip().flipNext();
  }

  prevPageAnim() {
    LazyPageLoader.lazyLoader(
      this.state.currentPage - 1,
      FlipEventType.prev,
      this.state.bookDb,
      this.state.currentPage
    );
    this.fbook.current.pageFlip().flipPrev();
  }

  restart() {
    this.sound?.stop();

    if (this.audioOnly) {
      return;
    }

    LazyPageLoader.lazyLoader(
      0,
      FlipEventType.restart,
      this.state.bookDb,
      this.state.currentPage
    );
    this.fbook.current.pageFlip().flip(0, "top");
  }

  pageLoaded(page: any, image: HTMLImageElement | null) {
    if (image && image.width > 2) {
      page.loaded = true;
    }
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

  private get canPlayAudio(): boolean {
    return (
      !!this.props.audioFileURL && this.props.book.type !== BookType.Regular
    );
  }

  private get audioOnly(): boolean {
    return this.props.book.type === BookType.AudioOnly;
  }

  render() {
    let minWidth = 315;
    if (isTablet) {
      // minWidth triggers 2-page view (if it can fit 2 * minWidth on the screen -> 2-page mode)
      // so tweak it a bit for tablets, to always show a single page in portrait mode and a
      // double-page in landscape
      const largest = Math.max(window.innerHeight, window.innerWidth);
      minWidth = largest / 2 - 10;
    }

    let scale = 1.0;
    if (isMobileOnly && isIOS && this.state.orientation == "landscape") {
      // iPhone messes up the landscape height, so force it to scale to prevents
      // pages from being cut off
      scale = 0.87;
    }

    return (
      <div className={"fbook-wrapper"} ref={this.container}>
        {!this.state.loaded && (
          <div style={{ width: "70px", height: "70px", margin: "0 auto" }}>
            <Loader type="Watch" color="#19c2f2" height={100} width={100} />
          </div>
        )}
        {this.state.loaded && (
          <div className="w-screen h-auto relative">
            {this.audioOnly ? (
              <img
                className={"mx-auto h-screen"}
                src={this.props.book.coverURL}
                alt="book-cover"
              />
            ) : (
              <>
                <div style={{ transform: `scale(${scale})` }}>
                  <Zoomable disabled={!isMobileOnly}>
                    <HTMLFlipBook
                      width={window.innerWidth / 2}
                      height={
                        this.state.coverHeight *
                        (window.innerWidth / 2 / this.state.coverWidth)
                      }
                      size={"stretch"}
                      minWidth={minWidth}
                      maxWidth={this.state.coverWidth}
                      minHeight={100}
                      maxHeight={this.state.coverHeight}
                      showCover={true}
                      drawShadow={true}
                      maxShadowOpacity={0.45}
                      startZIndex={0}
                      onFlip={this.onFlip}
                      ref={this.fbook}
                      className={"wingzzz-flipbook mx-auto"}
                      startPage={
                        this.state.currentPage === 1 ||
                        this.state.currentPage === 0
                          ? 0
                          : this.state.currentPage
                      }
                      flippingTime={1000}
                      autoSize={true}
                      style={{}}
                      usePortrait={true}
                      mobileScrollSupport={false}
                      renderOnlyPageLengthChange={false}
                      useMouseEvents={!isMobileOnly}
                      swipeDistance={30}
                      clickEventForward={true}
                      showPageCorners={false}
                      disableFlipByClick={false}
                    >
                      {this.state.bookDb.map((v: any, i) => (
                        <div
                          className="w-full h-full pointer-events-none bg-white"
                          key={i}
                        >
                          <LazyPage
                            ref={v["lazyRef"]}
                            page={v}
                            imgSrc={this.props.epubDirectory + v.href}
                            imageLoaded={this.pageLoaded}
                          />
                        </div>
                      ))}
                    </HTMLFlipBook>
                  </Zoomable>
                </div>
                <FlipControls
                  currentPage={this.state.currentPage}
                  totalPages={this.props.book.totalPages}
                  nextPage={this.nextPageAnim}
                  prevPage={this.prevPageAnim}
                />
              </>
            )}
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
