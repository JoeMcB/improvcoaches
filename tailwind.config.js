/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.{html,html.erb,erb}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/javascripts/**/*.js',
    './app/assets/stylesheets/**/*.{scss,css}'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
  corePlugins: {
    preflight: false, // Keep Bootstrap resets intact
  },
  // Disable future API changes that might not be compatible
  future: {
    disableColorOpacityUtilitiesByDefault: false,
    respectDefaultRingColorOpacity: false,
  }
}
