# Rails 7 Migration Guide

This document captures the **exact steps** needed to upgrade **this application** from
Rails 6.1 ➜ Rails 7.x while simultaneously

* dropping **Sprockets** in favour of **Propshaft**, and
* replacing **CoffeeScript** with modern **JavaScript**.

All commands assume you are at the project root and are executed from a
UNIX-like shell.  Wherever something needs manual intervention the step is
called-out explicitly.

---

## 0. Pre-flight checklist

1. Make sure the full test-suite passes on `main` *before* starting.
2. Create a **feature branch** for the upgrade:

   ```bash
   git checkout -b chore/upgrade-to-rails7
   ```
3. Ensure you are using a supported Ruby version.  Rails 7 supports **Ruby
   ≥ 2.7**; this project is already on `ruby "3.3.5"` so _no change is required_.
4. Update local tools (Bundler, Yarn, Node) to recent versions.

---

## 1. Gemfile changes

Open `Gemfile` and make the following edits:

| Action | Line(s) |
| --- | --- |
| **Bump Rails** | `gem "rails", "~> 7.1.3"` (or the newest 7.x release) |
| **Add Propshaft** | `gem "propshaft"` |
| **Remove Sprockets & helpers** | Delete `gem "sprockets"`, `sass-rails`, `uglifier` |
| **Remove CoffeeScript support** | Delete `gem "coffee-rails"` |
| **(optional) JavaScript tooling** | For simple apps rely on [Importmap](https://github.com/rails/importmap-rails); for bundling add `jsbundling-rails` + `esbuild` |
| **CSS tooling** | Replace `sass-rails` with `sassc-rails` **or** `cssbundling-rails` |

```ruby
# Example snippet – keep the rest of the Gemfile intact
gem "rails", "~> 7.1.3"
gem "propshaft"

# Asset tooling
gem "sassc-rails"          # compile SCSS without Sprockets
# gem "importmap-rails"    # uncomment if you wish to use importmaps
# gem "jsbundling-rails"   # …or use esbuild/webpack
```

Run Bundler:

```bash
bundle update rails && bundle install
```

If Bundler reports dependency conflicts, resolve them incrementally – usually by
upgrading the conflicting gems to the latest compatible releases.

---

## 2. Install new Rails defaults

Rails ships a generator that updates configuration files for the new version.

```bash
bin/rails app:update
```

Accept **all** new configuration files by writing them with `.rails7` suffixes
(the generator asks).  After the generator finishes, perform a three-way merge:

```bash
git mergetool   # or use your IDE
```

*Keep every existing project-specific setting* but incorporate **new Rails 7
defaults**.  Pay special attention to:

* `config/environments/*`
* `config/application.rb` (we add Propshaft here later)
* `config/initializers/*`

Commit the merged configs.

---

## 3. Enable Propshaft

1. Propshaft is already included in the Gemfile, so we can skip this first step.

2. Remove any old Sprockets configuration from
   `config/application.rb` **and** the individual environment files
   (`config/environments/development.rb`, etc.).  Examples that can be deleted or commented out:

   ```ruby
   config.assets.enabled = true
   config.assets.version  = '1.0'
   config.assets.paths    << …
   config.assets.precompile += …
   config.assets.compile = false
   config.assets.compress = …
   config.assets.quiet = true
   ```

3. Create a Propshaft manifest file:

   ```bash
   mkdir -p app/assets/config
   echo "//= link_tree ../images
//= link_tree ../builds
//= link application.css
//= link application.js" > app/assets/config/manifest.js
   ```

   Create a builds directory for Propshaft:
   
   ```bash
   mkdir -p app/assets/builds
   ```

4. Verify the asset prefix is still `/assets` (default).  In production, Rails
   now serves digested assets automatically through Propshaft; no extra nginx
   config is required.

5. Update the layout file to use the new asset helper syntax:

   ```ruby
   <%= stylesheet_link_tag "application", media: "all", "data-turbo-track": "reload" %>
   <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
   ```

6. Create a bin/propshaft helper script:

   ```bash
   cat <<EOT > bin/propshaft
#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../config/application"
require "propshaft"

ARGV.each do |command|
  case command
  when "compile"
    Rails.application.load_tasks
    Rake::Task["propshaft:compile"].invoke
  when "clean"
    Rails.application.load_tasks
    Rake::Task["propshaft:clean"].invoke
  when "clobber"
    Rails.application.load_tasks
    Rake::Task["propshaft:clobber"].invoke
  else
    puts "Unknown command: #{command}"
    puts "Available commands: compile, clean, clobber"
    exit 1
  end
end
EOT
   chmod +x bin/propshaft
   ```

---

## 4. Remove CoffeeScript

There are **14 CoffeeScript files** under `app/assets/javascripts/`:

```text
auth.js.coffee
cities.js.coffee
… (etc.)
```

They need to be converted to plain JavaScript and renamed to `.js`.

### 4.1 Automated conversion with _Decaffeinate_

Install the converter (requires Node ≥ 12):

```bash
npx decaffeinate --version   # should print a version number
```

Run the conversion:

```bash
# Decaffeinate doesn't support the --out flag as mentioned earlier
# Instead, convert the files in place
cd app/assets/javascripts
for file in *.coffee; do npx decaffeinate "$file"; done

# This generates files with .js.js extension, which we need to fix
for file in *.js.js; do mv "$file" "${file%.js.js}.js"; done
```

Now we can add the new JS files to git and remove the old coffee files:

```bash
git add app/assets/javascripts/*.js
git rm app/assets/javascripts/*.coffee
```

The generated JavaScript files are automatically cleaned up by decaffeinate, but you should still review them to ensure they work correctly in your application.

### 4.2 Manual clean-up checklist

* Remove outdated CoffeeScript-specific constructs (`@`, `->` etc.).
* Replace jQuery UJS calls with modern equivalents (Rails 7 uses `@rails/ujs`
  or `turbo`).
* Make sure every file ends with a **semi-colon** so Propshaft’s simple
  concatenation doesn’t break.

---

## 5. JavaScript strategy

For this application, we followed these steps:

1. Added the `jsbundling-rails` gem to the Gemfile
2. Ran `bin/rails javascript:install:esbuild` to set up esbuild
3. Created a modern entry point in `app/javascript/application.js`
4. Updated the manifest.js file to include both the legacy and modern JavaScript
5. Updated the application layout to use the new assets

**Important Note:** For legacy applications with jQuery dependencies, it's often safest to load jQuery globally via CDN rather than bundling it. This ensures it's available to all scripts and loaded in the correct order. We included jQuery via CDN in this order:

```html
<!-- jQuery must come before Bootstrap and other scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-ujs/1.2.3/rails.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
<%= javascript_include_tag "application" %>
```

### 5.1 Common JavaScript Migration Issues

1. **Document Ready Event Handling**: Convert all script code to use `$(document).ready()` instead of immediate execution:

```javascript
// Before - might execute before DOM is ready
$('#element').on('click', function() { ... });

// After - ensure DOM is ready
$(document).ready(function() {
  $('#element').on('click', function() { ... });
});
```

2. **jQuery UJS**: Include jquery-ujs from CDN for Rails helpers like `data-confirm`, `data-method`, etc.

3. **Bootstrap Integration**: Explicitly initialize Bootstrap components:

```javascript
$(document).ready(function() {
  // Initialize dropdown menus
  $('.dropdown-toggle').dropdown();
});
```

4. **Asset Path References**: Update any hardcoded asset paths in JavaScript files.

This creates a hybrid approach where:
- New JavaScript can be written as ES modules 
- Existing JavaScript continues to work via the asset pipeline and globally available jQuery
- We have a path to gradually migrate legacy code to modules

---

## 6. CSS strategy

For this application, we implemented a hybrid CSS strategy to handle both legacy and modern CSS:

1. Added the `cssbundling-rails` gem to the Gemfile
2. Ran `bin/rails css:install:tailwind` to install Tailwind CSS
3. Created `tailwind.config.js` to configure Tailwind
4. Created a new CSS entry point in `app/assets/stylesheets/application.tailwind.css`
5. Updated the asset pipeline to use Propshaft:

   ```ruby
   # config/initializers/assets.rb
   Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")
   Rails.application.config.assets.paths << Rails.root.join("app/assets/stylesheets")
   Rails.application.config.assets.prefix = "/assets"
   ```

6. Updated the manifest.js file:
   ```javascript
   //= link_tree ../images
   //= link_tree ../builds
   //= link_tree ../javascripts .js
   //= link application.css
   //= link app-legacy.css
   ```

7. Pre-copied the existing CSS to the builds directory:
   - Saved a copy of `application.css.scss` as `app-legacy.css` in the builds directory
   - This allows the legacy CSS to be served directly without SCSS processing

8. Updated the application layout to include both CSS files:
   ```erb
   <%= stylesheet_link_tag "application", "app-legacy", media: "all", "data-turbo-track": "reload" %>
   ```

9. Simplified build scripts:
   ```json
   "scripts": {
     "build:css": "yarn build:tailwind",
     "build:tailwind": "npx @tailwindcss/cli -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify"
   }
   ```

This creates a hybrid approach where:
- We can use Tailwind CSS for new components
- Existing CSS is served directly through Propshaft
- We have a path to gradually migrate to Tailwind classes

### 6.1 Common CSS Migration Issues

1. **Propshaft vs. Sprockets**: Propshaft does not process SCSS files like Sprockets did - you need to pre-compile SCSS files or use a separate processor
2. **Asset Path References**: Update any asset URLs in your CSS to use the new asset helpers
3. **Bootstrap Integration**: When using Bootstrap, ensure CSS and JS files are loaded in the correct order
4. **jQuery Dependencies**: jQuery and jQuery UI CSS should be explicitly included if needed

---

## 7. Update Rake tasks & initialisers

1. Search the codebase for any direct `Sprockets` references and delete/replace
   them.  Typical files: `config/initializers/assets.rb`, custom rake tasks,
   `<%= javascript_include_tag "application" %>` helpers in layouts.
   _With Propshaft those helpers work unchanged._
2. Search for `CoffeeScript` or `.coffee` references in views/tests and update.

> Tip: `git grep -nE "(Sprockets|\.coffee)"`.

---

## 8. Run the application locally

```bash
bin/rails server
```

Visit `http://localhost:3000` and click through **all** pages, watching the
browser console/network tab for missing assets or JavaScript errors.

Fix issues as you go – most are path or import-map typos.

---

## 9. Run the test-suite

```bash
bin/rails test          # Minitest
# or
bundle exec rspec       # if the project uses RSpec
```

Update any failing tests.  Common breakages:

* `assert_select` expectations that rely on old asset paths.
* JS-driven system tests that waited on Turbolinks events; switch to Turbo or
  add `data-turbo="false"`.

Commit once green.

---

## 10. Production verification checklist

1. Push the branch to staging and compile assets (`RAILS_ENV=production
   bin/rails assets:precompile`).  Propshaft will emit digested assets into
   `public/assets` automatically.
2. Confirm CloudFront / Nginx are still configured to serve
   `public/assets/`.
3. Roll through background workers (Resque), ensuring they load the new Rails
   version.

---

## 11. Final clean-up

* Delete `RAILS6_UPGRADE.md` or any doc that is no longer relevant.
* Update `README.md` badge / description to “Rails 7”.
* Squash-merge the branch:

  ```bash
  git checkout main
  git merge --squash chore/upgrade-to-rails7
  git commit -m "Upgrade application to Rails 7 + Propshaft"
  git push origin main
  ```

You are now running Rails 7 🥳.

---

## Appendix A – Useful references

* Rails 7 Release Notes – https://guides.rubyonrails.org/7_0_release_notes.html
* Propshaft README        – https://github.com/rails/propshaft
* Decaffeinate            – https://github.com/decaffeinate/decaffeinate

---

*Document generated — 2025-05-07*

---

## Appendix B - Modern JavaScript Architecture

As part of the Rails 7 modernization, we've completely restructured our JavaScript approach:

### 1. Removing jQuery Dependency

All jQuery code has been converted to pure vanilla JavaScript:

- Changed `$(document).ready()` to `document.addEventListener('DOMContentLoaded')`
- Replaced jQuery selectors (`$('.element')`) with vanilla equivalents (`document.querySelector()`, `document.querySelectorAll()`)
- Converted jQuery events to native event listeners (`addEventListener()`)
- Implemented custom polyfills for Bootstrap functionality that relied on jQuery
- For the selectable functionality (previously using jQuery UI), a simple vanilla JavaScript implementation was added

### 2. Modular JavaScript Architecture

We've completely refactored the JavaScript to use a modular ES6 pattern:

- **Directory Structure**:
  ```
  app/javascript/
  ├── application.js        # Main entry point
  ├── components/           # Reusable UI components
  │   └── tabs.js
  ├── pages/                # Page-specific functionality
  │   ├── schedules.js
  │   ├── search.js
  │   ├── spaces.js
  │   └── users.js
  └── utils/                # Shared utilities
      └── bootstrap-polyfills.js
  ```

- **Module Pattern**: Each file exports specific functionality that's imported where needed:
  ```javascript
  // pages/users.js
  export function initializeUserForms() {
    // Implementation details...
  }

  // application.js
  import { initializeUserForms } from './pages/users';
  ```

### 3. Build Pipeline

Modern bundling with esbuild:

- **Single Entry Point**: All JavaScript is loaded through the main application.js
- **Asset Pipeline**: No more direct serving of files from app/assets/javascripts
- **Simplified Build**: Added consolidated npm scripts:
  ```json
  "scripts": {
    "build:js": "esbuild app/javascript/application.js --bundle --sourcemap --format=esm --outdir=app/assets/builds --minify",
    "watch:js": "esbuild app/javascript/application.js --bundle --sourcemap --format=esm --outdir=app/assets/builds --watch",
    "start": "concurrently \"yarn watch:css\" \"yarn watch:js\""
  }
  ```

### 4. Integration with Rails

- Updated application layout to load one optimized bundle
- Removed inline JavaScript from application.html.erb
- Ensured Bootstrap compatibility with custom polyfills

### 5. Benefits

This migration provides numerous advantages:

- **Performance**: Smaller bundle size, optimized loading
- **Maintainability**: Clear organization, modular code
- **Modern Development**: ES6 modules, proper bundling
- **Simplicity**: Single source of truth, simplified configuration
- **Future-Proof**: Aligns with Rails 7's preferred JavaScript approach

The overall result is a clean, well-organized, maintainable JavaScript codebase that follows modern best practices.
