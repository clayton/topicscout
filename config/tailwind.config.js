const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'brand': {
          '50': '#fafafe', 
          '100': '#f4f6fe', 
          '200': '#e5e8fc', 
          '300': '#d5d9f9', 
          '400': '#b5bdf5', 
          '500': '#95a1f1', 
          '600': '#8691d9', 
          '700': '#7079b5', 
          '800': '#596191', 
          '900': '#494f76'
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
