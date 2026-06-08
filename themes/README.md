# Moodle Theme Templates

This directory contains theme templates that can be applied to sandbox instances.

## Available Themes

- **modern** - A modern, minimalist theme
- **classic** - Traditional Moodle appearance
- **minimal** - Stripped-down, lightweight theme

## Adding New Themes

1. Create a new directory under `themes/`
2. Add a `config.php` file with theme configuration
3. Optionally add CSS/JS in the theme directory
4. Create a deployment config in `config/<theme-name>.php`

## Theme Structure

```
themes/
  modern/
    config.php          # Theme configuration
    styles/             # CSS files
    javascript/         # JS files
  config/
    modern.php          # Deployment-time configuration
```
