const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./app/components/**/*",
  ],
  theme: {
    colors: {
      white: "#ffffff",
      black: "#000000",
      blue: "#1fb6ff",
      purple: "#7e5bef",
      pink: "#ff49db",
      orange: "#ff7849",
      green: "#13ce66",
      lightgreen: {
        500: "#c5ef80",
      },
      yellow: "#ffc82c",
      gray: {
        200: "#d3dce6",
        500: "#8492a6",
        600: "#313840",
        700: "#273444",
        800: "#2b3038",
        900: "#20242a",
      },
      red: {
        100: "#FEE2E2",
        400: "#F87171",
        700: "#B91C1C",
      },
      darkblue: {
        500: "#16202D",
      },
    },
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      opacity: {
        85: "0.85",
      },
      maxHeight: {
        300: "300px",
      },
      maxWidth: {
        r50: "50rem",
      },
      width: {
        logo: "30rem",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
