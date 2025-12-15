# Benji Connect iOS SDK

A Swift Package for integrating Benji Connect into your iOS apps.

## Installation

Add the package to your project using Xcode:

- File > Add Package Dependencies…
- Enter the repository URL of this SDK
- Choose the `BenjiConnect` library product

Minimum platform: iOS 14

## Usage

```swift
import BenjiConnect

let sdk = BenjiConnect()
print(sdk.hello()) // "Benji Connect SDK v0.1.0"
