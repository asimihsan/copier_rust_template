# Contributing

Thanks for your interest in contributing!

## Quick Start

Run `mise lint-all` before every PR to ensure your changes meet our quality standards.

## Development Setup

1. Install dependencies:

   ```bash
   ./scripts/dev-setup.sh
   mise install
   ```

2. Set up the project:

   ```bash
   mise setup
   ```

3. Run the development workflow:

   ```bash
   mise dev
   ```

## Testing

- Run all tests: `mise test`
- Run with coverage: `mise coverage`
- Run security audit: `mise audit`

## Code Style

- Format code: `mise format`
- Check formatting: `mise check-format`
- Run clippy: `mise check-clippy`

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `mise lint-all` to ensure quality
5. Submit a pull request

## Code of Conduct

Please be respectful and follow our community guidelines.

## Questions?

Feel free to open an issue for any questions or clarifications.
