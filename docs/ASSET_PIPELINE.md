# Asset Pipeline – Current State & Diagnostics (May 2025)

This document is meant to give **a single place of truth** about how front-end
assets (CSS, JS, images, fonts…) are **authored, built and served** in the
application as it runs today.  It is the result of a full source-tree audit and
should make it easier to debug the existing breakages and to make an informed
decision on what to keep, change or delete.

---

## 1 · High-level overview

| Layer | Responsibility | Implementation in this app |
|-------|---------------|----------------------------|
| **Serving** | Map logical pipeline URLs (e.g. `/assets/application.css`) to fingerprinted files on disk | **Propshaft** – default in Rails 7.1 |
| **Compilation / bundling** | Produce the artefacts that Propshaft will serve | • Tailwind CLI → `application.css`  <br>• (legacy) Sass compiler → many `*.css` files  <br>• ESBuild → `application.js` |
| **Authoring** | Source code developers work on | • Tailwind entry: `app/assets/stylesheets/application.tailwind.css`  <br>• ≈30 SCSS legacy files under `app/assets/stylesheets/`  <br>• ES-module JS under `app/javascript/`  <br>• Images under `app/assets/images/` |

The **runtime side (Propshaft)** is healthy – requests for `/assets/*` succeed
as long as the corresponding file exists in any directory listed in
`Rails.application.config.assets.paths`.

The **build side is where the current breakage occurs**: the scripts that are
supposed to turn SCSS and Tailwind sources into CSS either do not run or do not
produce the expected output.

---

## 2 · Configuration details

### 2.1 Propshaft (Rails)

File: `config/initializers/assets.rb` (no dedicated `propshaft.rb`). The key
lines:

```ruby
config.assets.paths << Rails.root.join("app/assets/builds")
config.assets.paths << Rails.root.join("app/assets/stylesheets")
config.assets.paths << Rails.root.join("app/assets/images")
config.assets.prefix = "/assets"
```

### 2.2 Front-end build scripts (`package.json`)

```jsonc
{
  "scripts": {
    "build"        : "yarn build:css && yarn build:js:once",
    "dev"          : "bin/dev",

    // CSS
    "build:css"    : "yarn build:tailwind && yarn build:legacy-css",
    "build:tailwind": "npx @tailwindcss/cli -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify",
    "build:legacy-css": "bin/compile-scss", // ← **broken – file missing**

    // JavaScript
    "build:js"     : "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets --external:/assets/* --watch",
    "build:js:once": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets --external:/assets/*"
  }
}
```

* **Tailwind** – builds fine → `app/assets/builds/application.css`.
* **ESBuild**  – builds fine → `app/assets/builds/application.js` (+ `.map`).
* **Legacy SCSS** – configured to run via `bin/compile-scss`, **but that file is
  missing**, therefore no legacy CSS is (re)built.

### 2.3 Expectations in the views

`app/views/layouts/application.html.erb` declares:

```erb
<%= stylesheet_link_tag "all-combined-legacy", "application" %>
```

* `application.css` – Tailwind output (✅ OK).
* `all-combined-legacy.css` – bundle of legacy SCSS (⚠️ **stale / missing**).

If the latter isn’t rebuilt, edits to any `*.css.scss` file never reach the
browser even though Rails starts happily.

---

## 3 · Symptoms seen by developers

1. Running `yarn build` or `bin/dev` logs **ENOENT: no such file or directory
   `bin/compile-scss`**.
2. The overall build sometimes continues (error swallowed by shell), giving the
   false impression that assets were built.
3. Pages only show Tailwind classes; site-specific styles are absent.

---

## 4 · Root-cause analysis

| # | Category | Root cause |
|---|----------|------------|
| 1 | Build tooling | `bin/compile-scss` script deleted / never committed, so legacy SCSS build step is broken. |
| 2 | Process hygiene | CI/CD doesn’t assert that `yarn build` succeeds. |
| 3 | Tech debt | Having **two** CSS stacks (Bootstrap-era SCSS *and* Tailwind) doubles the maintenance surface. |

---

## 5 · Recommended remediation plan

### Short term – get styles back

1. Re-add `bin/compile-scss` (make it executable):

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   npx sass --update app/assets/stylesheets:app/assets/builds --no-source-map
   ```
2. Have `package.json` use `&&` between sub-commands (or wrap in a script with
   `set -e`) so any failure aborts the build.

### Medium term – reduce complexity

3. Decide whether to **fully migrate to Tailwind** or keep the SCSS stack. If
   migrating, port critical rules and drop the SCSS compilation.
4. Add a CI job that runs `yarn build` and fails on any warning/error.

### Long term – ensure reproducibility

5. Remove compiled artefacts from Git (or add a guard that they are up-to-date).

---

## 6 · File-map cheat-sheet

```
app/assets/stylesheets/         ← SCSS (legacy)
app/assets/stylesheets/application.tailwind.css
app/assets/builds/              ← build outputs (JS + CSS)
app/javascript/                 ← ES-modules
docs/ASSET_PIPELINE.md          ← you are here ✅
```

---

_Generated 2025-05-07 by repository audit._
