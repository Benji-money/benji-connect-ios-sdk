# Contributing to BenjiConnect iOS SDK

Thank you for your interest in contributing to the BenjiConnect iOS SDK!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/benji-connect-ios-sdk.git`
3. Create a feature branch: `git checkout -b feature/my-feature`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes: `git commit -m "Add my feature"`
7. Push to your fork: `git push origin feature/my-feature`
8. Open a Pull Request

## Development Setup

### Requirements
- macOS 12.0+
- Xcode 13.0+
- Swift 5.5+

### Building the SDK

```bash
swift build
```

### Running Tests

```bash
swift test
```

Or use Xcode:
1. Open Package.swift in Xcode
2. Select the BenjiConnect scheme
3. Press Cmd+U to run tests

## Code Style

- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small
- Use Swift's type system effectively

## Testing

- Write unit tests for new features
- Ensure all tests pass before submitting a PR
- Test on multiple iOS versions if possible
- Test both Swift and Objective-C compatibility

## Pull Request Guidelines

### Before Submitting

- [ ] Code builds without errors or warnings
- [ ] All tests pass
- [ ] New code includes appropriate tests
- [ ] Documentation is updated if needed
- [ ] CHANGELOG.md is updated
- [ ] Code follows the project's style guidelines

### PR Description Should Include

- Brief description of changes
- Related issue number (if applicable)
- Testing performed
- Screenshots (for UI changes)
- Breaking changes (if any)

## Commit Messages

Use clear and descriptive commit messages:

```
Add feature: Brief description

Detailed explanation of what was changed and why.
Include any relevant context or decisions made.
```

## Documentation

- Update README.md for user-facing changes
- Update inline documentation for API changes
- Add examples for new features
- Keep documentation clear and concise

## Reporting Issues

When reporting issues, please include:

- iOS version
- Xcode version
- SDK version
- Minimal reproduction steps
- Expected vs actual behavior
- Relevant code snippets
- Error messages or logs

## Questions?

For questions about contributing, please open an issue or contact the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).
