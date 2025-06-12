# Contributing

Thanks for your interest in contributing!

## Quick Start

Run `just check-all` before every PR to ensure your changes meet our quality standards.

## Development Setup

1. Install dependencies:

   ```bash
   ./scripts/dev-setup.sh
   mise install
   ```

2. Set up the project:

   ```bash
   just setup
   ```

3. Run the development workflow:

   ```bash
   just dev
   ```

## Testing

- Run all tests: `just test`
- Run with coverage: `just coverage`
- Run security audit: `just audit`

## Code Style

- Format code: `just format`
- Check formatting: `just check-format`
- Run clippy: `just check-clippy`

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `just check-all` to ensure quality
5. Submit a pull request

## Code of Conduct

Please be respectful and follow our community guidelines.

## Questions?

Feel free to open an issue for any questions or clarifications.
