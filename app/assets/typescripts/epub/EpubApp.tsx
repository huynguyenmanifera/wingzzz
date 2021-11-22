import * as React from "react";
import classNames from "classnames";
import bookLength from "./services/bookLength";
import EpubReader from "./EpubReader";
import AnimatedFlipReader from "./AnimatedFlipReader";
import updateBookSession from "./services/updateBookSession";
import * as _ from "lodash";
import Analytics from "./services/Analytics";
import { progress, progressRatio } from "./services/progress";
import Book, { BookType, Layout } from "./Book";
import cachedEpubBook from "./services/cachedEpubBook";
import AnimatedReader from "./AnimatedReader";
import { Howl } from "howler";
import AudioOnlyReader from "./AudioOnlyReader";
import Loader from "react-loader-spinner";

interface EpubAppProps {
  epubFileURL: string;
  layout: Layout;
  stylesheetURL: string;
  bookSessionURL: string;
  initialPage: number;
  backURL: string;
  bookId: number;
  readerChoice: string;
  audioFileURL: string;
  bookType: BookType;
  coverURL: string;
}

interface EpubLoadedState {
  loaded: true;
  initialPage: number;
  initialAudio?: number;
  book: Book;
}

interface EpubLoadingState {
  loaded: false;
}

type EpubAppState = EpubLoadingState | EpubLoadedState;

export default class EpubApp extends React.Component<
  EpubAppProps,
  EpubAppState
> {
  private analytics: Analytics | null = null;
  private debouncedHandleNavigate: (currentPage: number) => void;
  private animated: boolean;
  private dimensions: object = { width: 0, height: 0 };
  private pageImages: Array<object> = [];
  private epubDirectory: String = "";

  constructor(props: EpubAppProps) {
    super(props);

    this.animated = this.props.readerChoice === "animated";

    this.state = {
      loaded: false,
    };

    this.debouncedHandleNavigate = _.debounce(this.handleNavigate, 1200);

    const epubBook = cachedEpubBook(this.props.epubFileURL);

    if (this.isAudioOnly) {
      this.loadAudioBook(this.props.audioFileURL);
    } else {
      bookLength(epubBook).then((totalPages) => {
        const book: Book = {
          epubFileURL: this.props.epubFileURL,
          coverURL: this.props.coverURL,
          layout: this.props.layout,
          totalPages,
          type: this.props.bookType,
        };

        const shouldStartOver =
          progressRatio(
            progress({
              book,
              currentPage: this.props.initialPage,
            })
          ) == 1;

        const initialPage = shouldStartOver ? 1 : this.props.initialPage;
        const initialAudio = this.isAudioOnly
          ? this.props.initialPage
          : undefined;

        this.analytics = Analytics.bookOpened(
          this.props.bookId,
          progress({
            book,
            currentPage: initialPage,
          })
        );

        this.epubDirectory = (epubBook.path as { [key: string]: any })[
          "directory"
        ];
        this.pageImages = (epubBook.resources as { [key: string]: any })[
          "assets"
        ];

        this.setState({
          loaded: true,
          book,
          initialPage,
          initialAudio,
        });
      });
    }
  }

  loadAudioBook(audioUrl: string) {
    const sound = new Howl({
      src: [audioUrl],
      preload: "metadata",
      onload: () => {
        const book: Book = {
          epubFileURL: this.props.epubFileURL,
          coverURL: this.props.coverURL,
          layout: this.props.layout,
          totalPages: Math.floor(sound.duration()),
          type: this.props.bookType,
        };

        this.setState({
          loaded: true,
          book,
          initialPage: this.props.initialPage,
          initialAudio: this.props.initialPage,
        });
      },
    });
  }

  onFinish(currentPage: number) {
    this.updateBookSession(currentPage).then(() => {
      window.location.href = this.props.backURL;
    });
  }

  onNavigate(currentPage: number) {
    this.debouncedHandleNavigate(currentPage);
  }

  handleNavigate(currentPage: number) {
    this.updateBookSession(currentPage);
  }

  updateBookSession(currentPage: number): Promise<Response> {
    return updateBookSession({
      bookSessionURL: this.props.bookSessionURL,
      csrfToken: (() => {
        const _window: any = window;
        return _window.csrfToken;
      })(),
    })(
      { currentPage },
      this.state.loaded
        ? this.analytics?.bookProgressChangeEvent(
            progress({
              book: this.state.book,
              currentPage,
            })
          )
        : undefined
    );
  }

  get isAudioOnly() {
    return this.props.bookType === BookType.AudioOnly;
  }

  // Render the animated reader only if necessary data is loaded, the reader is set in the Book instance, and there are more than 2 pages available for it
  render() {
    return (
      <div
        className={classNames({
          "w-screen": !this.animated,
          relative: !this.animated,
          "bg-wz-gray-700": !this.animated,
          "select-none": !this.animated,
        })}
      >
        {this.isAudioOnly && (
          <>
            {this.state.loaded ? (
              <AudioOnlyReader
                {...this.props}
                initialPage={this.state.initialPage}
                initialAudio={this.state.initialAudio}
                onFinish={this.onFinish.bind(this)}
                onNavigate={this.onNavigate.bind(this)}
                book={this.state.book}
              />
            ) : (
              <Loading />
            )}
          </>
        )}
        {this.state.loaded && !this.isAudioOnly && this.animated && (
          <div>
            {/*
            <AnimatedReader
              {...this.props}
              initialPage={this.state.initialPage}
              onFinish={this.onFinish.bind(this)}
              onNavigate={this.onNavigate.bind(this)}
              book={this.state.book}
              pageImages={this.pageImages}
              epubDirectory={this.epubDirectory}
            />
            */}
            <AnimatedFlipReader
              {...this.props}
              initialPage={this.state.initialPage}
              initialAudio={this.state.initialAudio}
              onFinish={this.onFinish.bind(this)}
              onNavigate={this.onNavigate.bind(this)}
              book={this.state.book}
              pageImages={this.pageImages}
              epubDirectory={this.epubDirectory}
            />
          </div>
        )}
        {this.state.loaded && !this.animated && (
          <EpubReader
            {...this.props}
            initialPage={this.state.initialPage}
            onFinish={this.onFinish.bind(this)}
            onNavigate={this.onNavigate.bind(this)}
            book={this.state.book}
          />
        )}
      </div>
    );
  }
}

const Loading = () => (
  <div className={"fbook-wrapper"}>
    <div style={{ width: "70px", height: "70px", margin: "0 auto" }}>
      <Loader type="Watch" color="#19c2f2" height={100} width={100} />
    </div>
  </div>
);
