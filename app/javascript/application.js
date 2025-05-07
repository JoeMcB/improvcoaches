// Entry point for the build script in your package.json

// We're using a global jQuery loaded via CDN in the layout
// This allows Bootstrap and other legacy scripts to work properly
// No need to import jQuery here since it's already available in the window

// Initialize modern JavaScript
console.log('Modern JavaScript now loaded');

// Initialize any modern components below
// ...

// Note: The old JavaScript files are included via the
// asset pipeline with Propshaft. We'll gradually move
// functionality to modules in the future.
