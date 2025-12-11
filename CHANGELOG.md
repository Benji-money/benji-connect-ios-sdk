# Changelog

All notable changes to the BenjiConnect iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-11

### Added
- Initial release of BenjiConnect iOS SDK
- Swift Package Manager support
- Objective-C compatibility via @objc annotations
- BenjiConnectConfig for configuring the SDK
- BenjiConnect main SDK class with present/dismiss methods
- BenjiConnectDelegate protocol for receiving events
- BenjiConnectEvent for event handling
- BenjiConnectWebView wrapper around WKWebView
- Support for multiple event types:
  - loaded
  - success
  - exit
  - error
  - accountSelected
  - institutionSelected
  - custom
- Error handling with BenjiConnectError
- Debug mode for development
- Comprehensive documentation and examples
- Unit tests for core functionality
- Swift and Objective-C example implementations

### Features
- iOS 12.0+ support
- Full-screen modal presentation
- Native navigation with close button
- Activity indicator for loading states
- JavaScript message passing between web and native
- Weak delegate pattern to prevent retain cycles
- Customizable configuration with metadata support
- Multiple environment support (production, sandbox, development)

[1.0.0]: https://github.com/Benji-money/benji-connect-ios-sdk/releases/tag/1.0.0
