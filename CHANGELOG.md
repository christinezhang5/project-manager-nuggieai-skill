# Changelog

All notable changes to the PM Vibe installer.

## [1.0.0] — April 2026

### Added
- Initial release of PM Vibe installer
- Token-based authentication via nuggieai.com
- Fetches full skill content from server on activation
- Supports pm on and /pm activation triggers
- Clear error messages for invalid tokens, network errors, and missing setup
- install.sh script for one-command setup on Mac and Linux

### How it works
The installer is a thin file that tells Claude where to fetch PM Vibe from.
All skill logic lives on nuggieai.com — updates are automatic.
