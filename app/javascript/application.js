// Entry point for the build script in your package.json
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"; // Ensure this is imported before Turbo
import Turbolinks from "turbolinks"; // Optional if using Turbo for navigation
import * as ActiveStorage from "@rails/activestorage";
import "semantic-ui-sass";
import "jquery";
import { Turbo } from "@hotwired/turbo-rails";

// Make jQuery available globally
window.jQuery = jquery;
window.$ = jquery;

// Initialize libraries
Rails.start(); // Initialize Rails UJS
Turbo.start(); // Start Turbo (if you want to handle navigation with Turbo instead of Turbolinks)
// Turbolinks.start(); // If you still want to use Turbolinks for non-Turbo interactions
ActiveStorage.start(); // For Active Storage functionality

// Optional: Remove `Turbolinks.start()` if you're fully using Turbo for navigation.
