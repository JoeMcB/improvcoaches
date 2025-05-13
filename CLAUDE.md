# Commands & Guidelines for ImprovCoaches

## Build & Run Commands
- Setup: `docker build . -t improvcoaches && docker-compose run web rake db:create && docker-compose run web rake db:seed`
- Run server: `docker-compose up`
- Rails console: `docker-compose run web rails c`
- Run all tests: `docker-compose run web rake test`
- Run single test: `docker-compose run web ruby -Itest test/path/to/test_file.rb -n test_method_name`
- Run rubocop: `docker-compose run web rubocop`
- Compile assets: `docker-compose run web bin/propshaft compile`

## Technology Stack
- **Ruby Version**: 3.3.5
- **Framework**: Rails 7.1.3
- **Asset Pipeline**: Propshaft (replacing Sprockets)
- **CSS Processing**: SCSS via cssbundling-rails + Tailwind CSS
- **JavaScript**: ES6 modules via jsbundling-rails + esbuild
- **Frontend Enhancements**: Turbo (Hotwire)
- **Storage**: Active Storage for file uploads

## Code Style Guidelines
- **Formatting**:
  - Indent with 2 spaces
  - Method params aligned with fixed indentation
  - Multiline method calls indented
- **Naming**: Follow Ruby conventions (snake_case for methods/variables, CamelCase for classes)
- **Error Handling**: Use Rails rescue_from for controllers, begin/rescue blocks sparingly
- **Model Relations**: Clearly define associations and validations at top of models
- **Testing**: Use built-in Rails test framework with fixtures
- **Documentation**: Add comments for complex logic, model validations, and controller actions
- **JavaScript**: Use modular ES6 pattern with imports/exports
- **CSS**: Use Tailwind utility classes for new components

## Asset Organization
- **JavaScript**: Stored in `app/javascript/` with modular structure
  - `components/` - Reusable UI components
  - `pages/` - Page-specific code
  - `utils/` - Shared utilities
- **CSS**: Hybrid approach
  - Legacy styles in `app/assets/stylesheets/`
  - New styles using Tailwind in `app/assets/stylesheets/application.tailwind.css`
- **Images**: Stored in `app/assets/images/`
- **Compiled assets**: Output to `app/assets/builds/`