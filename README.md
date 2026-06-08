# Moodle Sandbox Manager

A Podman-based Moodle sandbox environment with theme templates for quick deployment and testing.

## Quick Start

### Using Claude Code (Recommended)

```bash
/create-sandbox modern
```

This will deploy a Moodle instance with the modern theme on port 8080.

### Manual Usage

1. **Set environment variables** (optional)
   ```bash
   export MOODLE_PORT=8080
   export MOODLE_SITE_NAME="My Moodle Sandbox"
   ```

2. **Start the sandbox**
   ```bash
   podman compose up -d --build
   ```

3. **Access Moodle**
   - URL: http://localhost:8080
   - Username: `admin`
   - Password: `Admin123!`

4. **Stop the sandbox**
   ```bash
   podman compose down
   ```

5. **Remove all data**
   ```bash
   podman compose down -v
   ```

## Available Themes

- **modern** - Modern, minimalist design
- **classic** - Traditional Moodle appearance
- **minimal** - Lightweight, stripped-down theme

See `themes/README.md` for details on adding custom themes.

## Claude Code Skills

This project includes a custom `/create-sandbox` skill that automates deployment:

```bash
/create-sandbox [theme] [port] [site-name]
```

Examples:
```bash
/create-sandbox                           # Use defaults
/create-sandbox modern                    # Specify theme
/create-sandbox modern 8081              # Custom port
/create-sandbox classic 8082 "Test Site" # Full customization
```

## Project Structure

```
.
├── docker-compose.yml      # Podman orchestration
├── Dockerfile             # Moodle container image
├── scripts/
│   └── apply-theme.sh    # Theme application script
├── themes/               # Theme templates
│   ├── modern/
│   ├── classic/
│   └── minimal/
└── config/               # Theme deployment configs
```

## Requirements

- Podman (with compose support)
- 2GB+ available RAM
- 5GB+ available disk space

## Troubleshooting

### Port Already in Use
Change the port:
```bash
export MOODLE_PORT=8081
docker-compose up -d
```

### Container Won't Start
Check logs:
```bash
podman compose logs moodle
podman compose logs postgres
```

### Reset Everything
```bash
docker-compose down -v
docker-compose up -d --build
```

## Development

### Adding a New Theme

1. Create theme directory:
   ```bash
   mkdir -p themes/mytheme
   ```

2. Add `config.php`:
   ```php
   <?php
   defined('MOODLE_INTERNAL') || die();
   $THEME->name = 'mytheme';
   $THEME->parents = ['boost'];
   ?>
   ```

3. Add deployment config:
   ```bash
   cp config/modern.php config/mytheme.php
   ```

4. Deploy with your theme:
   ```bash
   /create-sandbox mytheme
   ```

## License

This is a development/testing tool. Moodle itself is licensed under GPL v3.
