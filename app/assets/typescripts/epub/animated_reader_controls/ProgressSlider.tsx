import React from "react";
import ReactSlider, { ReactSliderProps } from "react-slider";

interface ProgressSliderProps extends ReactSliderProps {}

const ProgressSlider: React.FC<ProgressSliderProps> = ({ ...props }) => {
  return (
    <ReactSlider
      min={0}
      thumbClassName="book-thumb"
      trackClassName="book-track"
      renderThumb={({ onFocus, ...props }, state) => {
        // remove onFocus from props to disable keyboard controls
        return (
          <div {...props} className="slider-mark border-0 outline-none">
            <div className="slider-mark-inner"></div>
          </div>
        );
      }}
      {...props}
    />
  );
};

export default ProgressSlider;
