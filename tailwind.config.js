module.exports = {
    content: [
      './app/views/**/*.{erb,haml,html,slim}',
      './app/helpers/**/*.rb',
      './app/assets/stylesheets/**/*.css',
      './app/javascript/**/*.js',
      './config/initializers/simple_form.rb',
      './lib/components/**/*.{erb,haml,html,slim}',
      './app/components/**/*.{erb,haml,html,slim}'
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  }