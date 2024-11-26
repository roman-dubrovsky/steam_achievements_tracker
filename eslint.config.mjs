import globals from "globals";
import eslintPluginImport from "eslint-plugin-import";
import eslintPluginJest from "eslint-plugin-jest";

/** @type {import('eslint').Linter.Config[]} */
export default [
  // Main configuration for general JavaScript files
  {
    languageOptions: {
      globals: globals.browser, // Browser globals (window, document, etc.)
      parserOptions: {
        ecmaVersion: 2020,  // Use modern ECMAScript features
        sourceType: "module", // Allow import/export syntax
      },
    },
    plugins: {
      import: eslintPluginImport,
      jest: eslintPluginJest,
    },
    rules: {
      // Manually adding rules from "eslint:recommended"
      "no-unused-vars": "warn", // Warn for unused variables
      "no-console": "warn", // Warn for console usage
      "eqeqeq": "error", // Require === and !==
      "curly": "error", // Require curly braces for all control statements

      // Manually adding rules from "plugin:import/errors"
      "import/no-unused-modules": "warn", // Warn about unused imports/modules
      // "import/no-unresolved": "error", // TODO: Ensure that imports point to valid modules

      // Manually adding rules from "plugin:jest/recommended"
      "jest/valid-expect": "warn", // Warn for invalid Jest expect calls
      "jest/no-disabled-tests": "warn", // Warn about disabled tests in Jest
    },
  },

  // Configuration for Jest test files
  {
    files: ["**/*.test.js", "**/*.spec.js"], // Apply Jest environment to test files
    languageOptions: {
      globals: {
        ...globals.browser,
        jest: true, // Jest globals for test files
      },
      parserOptions: {
        ecmaVersion: 2020,  // Use modern ECMAScript features
        sourceType: "module", // Allow import/export syntax
      },
    },
    rules: {
      // Additional Jest-specific rules can go here
      "jest/valid-expect": "warn", // Warn for invalid Jest expect calls
      "jest/no-disabled-tests": "warn", // Warn about disabled tests in Jest
    },
  },
  {
    ignores: ["coverage/*"],
  },
];
