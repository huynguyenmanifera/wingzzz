module.exports = {
  theme: {
    extend: {
      boxShadow: {
        default:
          "0 1px 3px 0 rgba(0, 0, 0, .2), 0 1px 2px 0 rgba(0, 0, 0, .12)",
        md:
          "0 4px 6px -1px rgba(0, 0, 0, .2), 0 2px 4px -1px rgba(0, 0, 0, .12)",
        lg:
          "0 10px 15px -3px rgba(0, 0, 0, .2), 0 4px 6px -2px rgba(0, 0, 0, .1)",
        xl:
          "0 20px 25px -5px rgba(0, 0, 0, .2), 0 10px 10px -5px rgba(0, 0, 0, .08)",
      },
      colors: {
        "wz-white": "#FFFFFF",
        "wz-white-trn-700": "rgba(255, 255, 255, 0.75)",
        "wz-white-trn-500": "rgba(255, 255, 255, 0.50)",
        "wz-white-trn-300": "rgba(255, 255, 255, 0.25)",

        "wz-dm-blue-200": "#f7f8f9",
        "wz-dm-blue-300": "#edf2f9",
        "wz-dm-blue-400": "#E5ECF5",
        "wz-dm-blue-500": "#b5c9e3",
        "wz-dm-blue-600": "#a4b1c2",

        "wz-beige-500": "#FFF2E0",

        "wz-red-200": "#f48c9c",
        "wz-red-300": "#f27080",
        "wz-red-400": "#ff8095",
        "wz-red-500": "#ff4562",
        "wz-red-600": "#eb435e",
        "wz-red-700": "#e72747",
        "wz-red-800": "#db0023",

        "wz-light-blue-50": "#e1f1f7",
        "wz-light-blue-100": "#9fd8eb",
        "wz-light-blue-200": "#a0d3e5",
        "wz-light-blue-300": "#6db8d5",
        "wz-light-blue-400": "#58cef3",
        "wz-light-blue-500": "#19C2F2",
        "wz-light-blue-600": "#0f9ece",
        "wz-light-blue-700": "#1587ac",

        "wz-light-gray": "f5f5f5",

        "wz-purple-300": "#9036A8",
        "wz-purple-500": "#84319B",
        "wz-purple-800": "#21202d",

        "wz-blue-500": "#1A187E",
        "wz-blue-400": "#1D4C8F",
        "wz-blue-600": "#181439",
        "wz-blue-700": "#000F2C",

        "wz-gray-300": "#F5F5F5",
        "wz-gray-400": "#E4E3E8",
        "wz-gray-500": "#AEACB9",
        "wz-gray-600": "#858395",
        "wz-gray-700": "#333333",
        "wz-black": "#000000",
        "wz-black-opacity-0": "rgba(0, 0, 0, 0)",
        "wz-black-opacity-25": "rgba(0, 0, 0, 0.25)",
        "wz-black-opacity-50": "rgba(0, 0, 0, 0.5)",
      },
      fontFamily: {
        sans: ["Poppins", "Helvetica", "Arial", "sans-serif"],
      },
      borderRadius: {
        sm: "0.2rem",
        default: "0.5rem",
      },
      borderWidth: {
        3: "3px",
      },
      spacing: {
        "5/2": "0.65rem",
        9: "2.25rem",
        "screen/20": "calc(100vh / 20)",
      },
      transitionProperty: {
        width: "width",
      },
      opacity: {
        85: ".85",
      },
    },
  },
  variants: {
    margin: ["last", "responsive"],
  },
  plugins: [],
};
