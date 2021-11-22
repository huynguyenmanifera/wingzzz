import * as React from "react";
import EpubRendition from "./EpubRendition";
import { rendition } from "./services/navigationBehavior";
import {
  renditionKey,
  renditionsAhead,
  renditionsBefore,
} from "./services/renditionBuffer";
import * as _ from "lodash";
import classNames from "classnames";
import Book from "./Book";

interface EpubRenditionsProps {
  stylesheetURL: string;
  currentPage: number;
  book: Book;
}

const config = {
  bufferRenditionsBefore: 1,
  bufferRenditionsAhead: 2,
};

export default class EpubRenditions extends React.PureComponent<EpubRenditionsProps> {
  get currentRendition() {
    return rendition({
      currentPage: this.props.currentPage,
      book: this.props.book,
    });
  }

  get renditions() {
    return renditionsBefore(this.props)(config.bufferRenditionsBefore).concat(
      [this.currentRendition],
      renditionsAhead(this.props)(config.bufferRenditionsAhead)
    );
  }

  render() {
    return (
      <>
        {this.renditions.map((rendition, index) => (
          <div
            key={renditionKey(rendition)}
            data-visible={
              _.isEqual(rendition, this.currentRendition) ? "true" : "false"
            }
            className={classNames(
              _.isEqual(rendition, this.currentRendition)
                ? "opacity-100"
                : "opacity-0"
            )}
          >
            <EpubRendition rendition={rendition} {...this.props} />
          </div>
        ))}
      </>
    );
  }
}
