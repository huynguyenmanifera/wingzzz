import * as React from "react";
import EpubPage, { Alignment } from "./EpubPage";
import { Rendition } from "./services/navigationBehavior";
import Book, { Layout } from "./Book";

interface EpubRenditionProps {
  stylesheetURL: string;
  rendition: Rendition;
  book: Book;
}

export default class EpubRendition extends React.PureComponent<EpubRenditionProps> {
  get styles(): React.CSSProperties[] {
    switch (this.props.rendition.layout) {
      case Layout.SinglePage:
        return [
          {
            width: "100%",
            height: "100%",
            display: "block",
            position: "absolute",
            top: 0,
            right: 0,
            left: 0,
          },
        ];

      case Layout.TwoPages:
        return [
          {
            width: "50%",
            height: "100%",
            display: "block",
            position: "absolute",
            top: 0,
            left: 0,
          },
          {
            width: "50%",
            height: "100%",
            display: "block",
            position: "absolute",
            top: 0,
            right: 0,
          },
        ];
    }
  }

  get alignments(): Alignment[] {
    switch (this.props.rendition.layout) {
      case Layout.SinglePage:
        return [Alignment.Center];

      case Layout.TwoPages:
        return [Alignment.Right, Alignment.Left];
    }
  }

  get pages(): number[] {
    switch (this.props.rendition.layout) {
      case Layout.SinglePage:
        return [this.props.rendition.page];

      case Layout.TwoPages:
        return [this.props.rendition.leftPage, this.props.rendition.rightPage];
    }
  }

  render() {
    return (
      <div>
        {this.pages.map((page, index) => {
          return (
            <div style={this.styles[index]} key={page}>
              <EpubPage
                key={page}
                book={this.props.book}
                stylesheetURL={this.props.stylesheetURL}
                page={page}
                alignment={this.alignments[index]}
              />
            </div>
          );
        })}
      </div>
    );
  }
}
