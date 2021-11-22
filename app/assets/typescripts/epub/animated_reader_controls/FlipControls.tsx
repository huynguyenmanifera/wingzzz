import * as React from "react";
import Icon from "../../ui/Icon";
interface FlipControlProps {
  currentPage: number;
  totalPages: number;

  nextPage: (action: FlipEventType) => void;
  prevPage: (action: FlipEventType) => void;
}

interface EFlipControlState {
  prevVisibleMobile: any;
  nextVisisbleMobile: any;
}

enum FlipEventType {
  "next",
  "prev",
  "slide",
  "restart",
  "initial",
  "user_fold",
}

export default class FlipControls extends React.Component<
  FlipControlProps,
  EFlipControlState
> {
  constructor(props: FlipControlProps) {
    super(props);

    this.state = {
      prevVisibleMobile: null,
      nextVisisbleMobile: null,
    };

    this.nextPage = this.nextPage.bind(this);
    this.prevPage = this.prevPage.bind(this);
  }

  nextPage() {
    clearTimeout(this.state.nextVisisbleMobile);
    const nextVisisbleMobile = setTimeout(
      () => this.setState({ nextVisisbleMobile: null }),
      1000
    );
    this.setState({ nextVisisbleMobile });
    this.props.nextPage(FlipEventType.next);
  }

  prevPage() {
    clearTimeout(this.state.prevVisibleMobile);
    const prevVisibleMobile = setTimeout(
      () => this.setState({ prevVisibleMobile: null }),
      1000
    );
    this.setState({ prevVisibleMobile });
    this.props.prevPage(FlipEventType.prev);
  }

  render() {
    return (
      <div>
        {this.props.currentPage > 0 && (
          <button
            onClick={this.prevPage}
            className="flipPrev absolute w-1/6 h-full lg:h-auto lg:w-1/4 border-0 outline-none"
          >
            <div
              className={`flipButtonContainer border-0 outline-none ${
                this.state.prevVisibleMobile ? "visible-mobile" : ""
              }`}
            >
              <Icon size="large" type="page-back" />
            </div>
          </button>
        )}
        {/* Render button only if there are still enough pages to flip at least once */}
        {this.props.totalPages - 1 > this.props.currentPage && (
          <button
            onClick={this.nextPage}
            className="flipNext absolute w-1/6 h-full lg:h-auto lg:w-1/4 border-0 outline-none"
          >
            <div
              className={`flipButtonContainer border-0 outline-none ${
                this.state.nextVisisbleMobile ? "visible-mobile" : ""
              }`}
            >
              <Icon size="large" type="page-forward" />
            </div>
          </button>
        )}
      </div>
    );
  }
}
