import * as React from "react";
import * as Epub from "epubjs";
import * as _ from "lodash";
import contentFit from "../helpers/contentFit";
import classNames from "classnames";
import Book from "./Book";
import EpubApp from "./EpubApp";
import cachedEpubBook from "./services/cachedEpubBook";

export enum Alignment {
  Center = "center",
  Right = "right",
  Left = "left",
}

interface EpubPageProps {
  stylesheetURL: string;
  page: number;
  alignment: Alignment;
  book: Book;
}

export default class EpubPage extends React.PureComponent<EpubPageProps> {
  private container: React.RefObject<HTMLDivElement>;
  private rendition: Epub.Rendition | undefined;
  private book: Epub.Book;

  constructor(props: EpubPageProps) {
    super(props);
    this.container = React.createRef();
    this.book = cachedEpubBook(this.props.book.epubFileURL);
  }

  componentDidMount() {
    /*
      By default EPubJS uses iframe.srcdoc to load EPUB contents into
      iframes. A bug in Firefox causes the browser to resolve relative
      URLS from the EPUB incorrectly, resulting in a _lot_ of bogus
      requests that cause unnecessary load on the backend.

      Unfortunately the 'write' method triggers another bug in Chrome,
      so 'write' is only used in FF.

      Note that the type specs don't allow this option, so I'm working
      around Typescript here...

      See https://github.com/futurepress/epub.js/issues/946 and
      https://bugzilla.mozilla.org/show_bug.cgi?id=1464344.
    */
    const isFF = navigator.userAgent.toLowerCase().indexOf("firefox") > -1;
    const undocumentedOptions = {
      method: isFF ? "write" : "srcdoc",
    };

    if (!this.container.current) {
      throw `Couldn't find container ${this.container.current}`;
    }

    this.rendition = this.book.renderTo(this.container.current, {
      flow: "paginated",
      width: "100%",
      height: "100%",
      minSpreadWidth: Number.MAX_SAFE_INTEGER,
      stylesheet: this.props.stylesheetURL,
      ...undocumentedOptions,
    });

    this.rendition.hooks.content.register(
      this.visuallyAlignEpubContents.bind(this)
    );

    this.updateRendition();
  }

  componentDidUpdate() {
    this.updateRendition();
  }

  private updateRendition() {
    if (!this.rendition) return;

    const target = this.props.page - 1;
    this.rendition.display(target);
  }

  private visuallyAlignEpubContents(
    contents: any /* Epub.Content, bug in type definition */
  ) {
    const containerElement = this.container.current;
    if (!containerElement) {
      console.error("Could not find container element");
      return;
    }

    const iframe = this.container.current?.querySelector("iframe");
    if (!iframe) {
      console.error("Could not find iframe element");
      return;
    }

    const iframeBody = iframe.contentWindow?.document.querySelector("body");
    if (!iframeBody) {
      console.error("Could not find body element within iframe");
      return;
    }

    const contentDimensions = {
      width: parseInt(contents.width()),
      height: parseInt(contents.height()),
    };

    const containerDimensions = {
      width: containerElement.clientWidth,
      height: containerElement.clientHeight,
    };

    const fittedContentDimensions = contentFit({
      content: contentDimensions,
      container: containerDimensions,
    });

    if (!fittedContentDimensions) {
      console.error("Could not fit content");
      return;
    }

    const marginTop =
      (containerDimensions.height - fittedContentDimensions.height) / 2;

    const marginLeft = (() => {
      switch (this.props.alignment) {
        case Alignment.Left:
          return 0;

        case Alignment.Center:
          return (
            (containerDimensions.width - fittedContentDimensions.width) / 2
          );

        case Alignment.Right:
          return containerDimensions.width - fittedContentDimensions.width;
      }
    })();

    iframeBody.style.position = "absolute";
    iframeBody.style.top = `${marginTop}px`;
    iframeBody.style.left = `${marginLeft}px`;
  }

  render() {
    return (
      <div
        ref={this.container}
        className={classNames("w-full", "h-full", "pointer-events-none")}
      />
    );
  }
}
