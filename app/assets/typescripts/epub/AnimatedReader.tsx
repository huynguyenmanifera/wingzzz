import * as React from "react";
import * as _ from "lodash";
import { NavState } from "./services/navigationBehavior";
import screenfull, { Screenfull } from "screenfull";
import HTMLFlipBook from "react-pageflip";
import FlipControls from "./animated_reader_controls/FlipControls";
import BottomToolbar from "./animated_reader_controls/BottomToolbar";
import * as LazyPageLoader from "./services/lazyPageLoader";
import Loader from "react-loader-spinner";
import LazyPage from "./LazyPage";
import { useGesture } from "react-use-gesture";
import { isIOS, isMobileOnly } from "react-device-detect";

enum FlipEventType {
  "next",
  "prev",
  "slide",
  "restart",
  "user_fold",
  "flipping",
}

export default function AnimatedReader(props: any) {
  let [currentPage, setCurrentPage] = React.useState(
    props.initialPage === 1 ||
      _.range(props.book.totalPages - 4, props.book.totalPages, 1).includes(
        props.initialPage
      )
      ? 0
      : props.initialPage
  );
  let [fullscreen, setFullscreen] = React.useState(false);
  let [loaded, setLoaded] = React.useState(false);
  let [bookDb, setBookDb] = React.useState(
    props.pageImages.map((img: any, i: number) => {
      img["lazyRef"] = React.createRef();
      img["loaded"] = false;
      img["page"] = i;
      return img;
    })
  );
  let [coverWidth, setCoverWidth] = React.useState(0);
  let [coverHeight, setCoverHeight] = React.useState(0);

  let [crop, setCrop] = React.useState({ x: 0, y: 0, scale: 1 });
  let readerRef: any = React.useRef();
  let gestureTarget: any = React.useRef();
  let container = React.useRef<HTMLDivElement>(null);

  LazyPageLoader.imageLoader(bookDb[0], props.epubDirectory).then((e: any) => {
    setCoverHeight(e.height);
    setCoverWidth(e.width);
    LazyPageLoader.lazyLoader(
      currentPage,
      FlipEventType.slide,
      bookDb,
      currentPage
    );
    setLoaded(true);
  });

  React.useEffect(() => {
    window.addEventListener("keydown", onKeyDown, false);
    if (screenfull.isEnabled) {
      (screenfull as Screenfull).on("change", onScreenfullChange);
    }
  }, [props.onNavigate(currentPage)]);

  useGesture(
    {
      onDrag: ({ offset: [dx, dy], vxvy: [vx], last }) => {
        let calcX = crop.scale > 1 ? dx : 0;
        let calcY = crop.scale > 1 ? dy : 0;
        setCrop((crop) => ({ ...crop, x: calcX, y: calcY }));
      },
      onPinch: ({ offset: [d] }) => {
        setCrop((crop) => ({
          ...crop,
          scale: 1 + d / 100 > 1 ? 1 + d / 100 : 1,
        }));
      },
    },
    {
      domTarget: loaded ? gestureTarget : container,
      eventOptions: { passive: false },
    }
  );

  const toggleFullscreen = () => {
    if (!screenfull.isEnabled) return;

    if (fullscreen) {
      (screenfull as Screenfull).exit();
    } else {
      container.current &&
        (screenfull as Screenfull).request(container.current);
    }

    setFullscreen((screenfull as Screenfull).isFullscreen);
  };

  const onFinish = () => {
    setCurrentPage;
    props.onFinish(0);
  };

  const onScreenfullChange = () => {
    setFullscreen((screenfull as Screenfull).isFullscreen);
  };

  const onKeyDown = (event: KeyboardEvent) => {
    switch (event.code) {
      case "ArrowRight":
        nextPageAnim();
        return;
      case "Space":
      case "ArrowLeft":
        prevPageAnim();
        return;
    }
  };

  const onFlip = (e: any) => {
    LazyPageLoader.lazyLoader(
      e.data,
      FlipEventType.user_fold,
      bookDb,
      currentPage
    );
    setCurrentPage(e.data);
  };

  const slideTo = (num: number) => {
    LazyPageLoader.lazyLoader(num, FlipEventType.slide, bookDb, currentPage);
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().turnToPage(num);
    }
  };

  const nextPageAnim = () => {
    LazyPageLoader.lazyLoader(
      currentPage + 1,
      FlipEventType.next,
      bookDb,
      currentPage
    );
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().flipNext();
    }
  };

  const prevPageAnim = () => {
    LazyPageLoader.lazyLoader(
      currentPage - 1,
      FlipEventType.prev,
      bookDb,
      currentPage
    );
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().flipPrev();
    }
  };

  const turnNext = () => {
    LazyPageLoader.lazyLoader(
      currentPage + 1,
      FlipEventType.next,
      bookDb,
      currentPage
    );
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().turnToNextPage();
    }
  };

  const turnPrev = () => {
    LazyPageLoader.lazyLoader(
      currentPage + 1,
      FlipEventType.next,
      bookDb,
      currentPage
    );
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().turnToPrevPage();
    }
  };

  const restart = () => {
    LazyPageLoader.lazyLoader(0, FlipEventType.restart, bookDb, currentPage);
    if (readerRef && readerRef.current) {
      readerRef.current.pageFlip().turnToPage(0);
    }
  };

  const pageLoaded = (page: any, image: HTMLImageElement | null) => {
    if (image && image.width > 2) {
      page.loaded = true;
    }
  };

  const navState = (): NavState => {
    return {
      book: props.book,
      currentPage: currentPage,
    };
  };

  return (
    <>
      <div className={"fbook-wrapper"} ref={container}>
        {!loaded && (
          <div style={{ width: "70px", height: "70px", margin: "0 auto" }}>
            <Loader type="Watch" color="#19c2f2" height={100} width={100} />
          </div>
        )}
        {loaded && (
          <div
            className="w-screen h-auto relative"
            style={{
              left: crop.x,
              top: crop.y,
              touchAction: "none",
              transform: `scale(${crop.scale})`,
            }}
          >
            <div
              className="w-screen h-auto relative overflow-hidden"
              ref={gestureTarget}
            >
              <HTMLFlipBook
                width={window.innerWidth / 2}
                height={coverHeight * (window.innerWidth / 2 / coverWidth)}
                size={"stretch"}
                minWidth={315}
                maxWidth={coverWidth}
                minHeight={100}
                maxHeight={coverHeight}
                showCover={true}
                drawShadow={true}
                maxShadowOpacity={0.45}
                startZIndex={0}
                onFlip={onFlip}
                ref={readerRef}
                className={"wingzzz-flipbook mx-auto"}
                startPage={
                  currentPage === 1 || currentPage === 0 ? 0 : currentPage
                }
                flippingTime={1000}
                autoSize={true}
                style={{}}
                usePortrait={true}
                mobileScrollSupport={false}
                renderOnlyPageLengthChange={false}
                useMouseEvents={crop.scale === 1 ? true : false}
                swipeDistance={30}
                clickEventForward={crop.scale === 1 ? true : false}
                showPageCorners={crop.scale === 1 ? true : false}
                disableFlipByClick={isMobileOnly}
              >
                {bookDb.map((v: any, i: number) => (
                  <div
                    className="w-full h-full pointer-events-none	bg-white"
                    key={i}
                  >
                    <LazyPage
                      ref={v["lazyRef"]}
                      page={v}
                      imgSrc={props.epubDirectory + v.href}
                      imageLoaded={pageLoaded}
                    />
                  </div>
                ))}
              </HTMLFlipBook>
              <FlipControls
                currentPage={currentPage}
                totalPages={props.book.totalPages}
                nextPage={isIOS && isMobileOnly ? turnNext : nextPageAnim}
                prevPage={isIOS && isMobileOnly ? turnPrev : prevPageAnim}
              />
              <BottomToolbar
                currentPage={currentPage}
                totalPages={props.book.totalPages}
                restart={restart}
                sliderFlip={slideTo}
                finish={onFinish}
                fullscreen={toggleFullscreen}
                isFullscreen={fullscreen}
              />
            </div>
          </div>
        )}
      </div>
    </>
  );
}
