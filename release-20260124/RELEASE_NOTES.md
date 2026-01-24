# ArttulOS, PacNixum, and AI Assistant - Release Notes

## Version: 1.0.0 (2026-01-24)

### Major Features
- Unified package manager (PacNixum) with RHEL, Arch, and Nix support
- Modular AI Assistant with Docker-based backends, plugin system, and GUI/TUI
- Security: rootless mode, resource limits, network isolation, plugin permission enforcement
- Logging, error handling, and user-friendly onboarding
- Performance benchmarking option in CLI
- Comprehensive documentation and onboarding guides

### Improvements
- Plugin loader now enforces permissions and prompts for dangerous actions
- All Docker containers can be run with enforced security/resource flags
- Logging and error reporting stubs in PacNixum CLI
- Contribution, conduct, and roadmap docs added

### Known Issues
- Some backend logic in PacNixum is still a skeleton (see logs for errors)
- Plugin sandboxing is planned but not fully implemented
- Performance benchmarks are stubs; more profiling to come

### How to Get Started
- See ONBOARDING.md for setup and contribution
- See subproject READMEs for usage and details

---
Thank you for using and contributing to ArttulOS!
