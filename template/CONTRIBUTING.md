# Contributing

Thanks for your interest in contributing!

## Quick Start

Run `mise run ci` before every PR to exercise the canonical local pipeline.

## Development Setup

1. Install dependencies:

   ```bash
   ./scripts/dev-setup.sh
   mise install
   ```

2. Set up the project:

   ```bash
   mise run setup
   ```

3. Run the development workflow:

   ```bash
   mise run dev
   ```

## Testing

- Run the default suite: `mise run test`
- Run doctests: `mise run rust:test-doc`
- Run coverage: `mise run rust:coverage`
- Run audits: `mise run rust:audit`
- Check for outdated dependencies: `mise run rust:outdated`
- Exercise snapshot tests: `mise run rust:insta-test`
- Review snapshots: `mise run rust:insta-review`

## Code Style

- Format code: `mise run format`
- Check formatting: `mise run check-format`
- Run clippy: `mise run check-clippy`

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `mise run ci` to ensure quality
5. Submit a pull request

## Code of Conduct

Please be respectful and follow our community guidelines.

## Questions?

Feel free to open an issue for any questions or clarifications.
