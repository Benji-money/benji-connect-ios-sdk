# Benji Connect iOS SDK

A Swift Package for integrating Benji Connect into your iOS apps.

## Installation

Add the package to your project using Xcode:

- File > Add Package Dependencies…
- Enter the repository URL of this SDK
- Choose the `BenjiConnect` library product

Minimum platform: iOS 16

## Usage

```swift
import BenjiConnect

let config = BenjiConnectConfig(
    environment: .staging,
    token: <connect token>,
    onSuccess: { token, metadata in
        print("✅ SUCCESS", token)
    },
    onError: { error, errorID, metadata in
        print("🛑 ERROR", error, errorID)
    },
    onExit: { metadata in
        print("🚪 EXIT", metadata)
    },
    onEvent: { type, metadata in
        print("📨 EVENT", type)
    }
)

let sdk = BenjiConnectSDK(config: config)
self.sdk = sdk
sdk.open(from: presenter)
