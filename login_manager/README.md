# ArttulOS Custom Login Manager

A secure, minimal, and accessible login manager for ArttulOS, featuring onboarding and accessibility options.

## Features
- Username/password login
- Session selection
- Onboarding wizard for first-time users
- Accessibility: screen reader, high-contrast mode, keyboard navigation

## Structure
- `login_manager.py`: Main login UI
- `onboarding_wizard.py`: Guided setup
- `accessibility.py`: Accessibility features
- `assets/`: Icons, stylesheets, accessibility resources

## Usage
- Replace your display manager with this login manager
- Systemd service included for startup
- See `PLAN.md` for implementation details
