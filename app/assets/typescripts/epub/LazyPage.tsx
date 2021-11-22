import * as React from "react";
interface LazyPageProps {
  page: any;
  imgSrc: string;

  imageLoaded: (page: any, image: HTMLImageElement | null) => void;
}

interface LazyPageState {
  needed: boolean;
  imgSrc: string;
  loading: boolean;
}

export default class LazyPage extends React.Component<
  LazyPageProps,
  LazyPageState
> {
  private placeholder: string;
  private pageImage: React.RefObject<HTMLImageElement>;

  constructor(props: LazyPageProps) {
    super(props);

    this.state = {
      needed: this.props.page.needed,
      imgSrc: "",
      loading: false,
    };

    this.pageImage = React.createRef();
    this.placeholder =
      "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkqAcAAIUAgUW0RjgAAAAASUVORK5CYII=";

    this.imageLoaded = this.imageLoaded.bind(this);
  }

  loadImage() {
    this.setState({
      needed: true,
    });
  }

  imageLoaded() {
    if (this.pageImage.current != null && this.pageImage.current.complete) {
      this.props.imageLoaded(this.props.page, this.pageImage.current);
    }
  }

  render() {
    return (
      <div className="w-full h-full bg-white">
        <img
          src={this.state.needed ? this.props.imgSrc : this.placeholder}
          ref={this.pageImage}
          onLoad={this.imageLoaded}
          className="w-full h-full pointer-events-none"
          alt={this.props.imgSrc.split("/")[-1]}
        />
      </div>
    );
  }
}
