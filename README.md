# Benji Connect iOS SDK

A Swift Package SDK for integrating Benji Connect, Benji's authentication and verification services.

## Installation

Add the package to your project using Xcode:

- File > Add Package Dependencies…
- Enter the repository URL of this SDK
- Choose the `BenjiConnect` library product

Minimum platform: iOS 15

## Usage

### Swift

See below an example code snippet which initializes and opens the sdk

```swift
import BenjiConnect

guard let presenter = UIApplication.shared.keyWindowRootViewController else {
    print("❌ Could not find root view controller")
    return
}

const sdk = BenjiConnectSDK(
    environment: .staging, // or .production | .development
    token: token,
    onSuccess: { token, metadata in
        print("✅ Benji Connect onSuccess")
    },
    onError: { error, errorID, metadata in
        print("🛑 Benji Connect onError")
    },
    onExit: { metadata in
        print("🚪 Benji Connect onExit")
    },
    onEvent: { type, metadata in
        print("📨 Benji Connect onEvent \(type)")
    }
)

sdk.open(from: presenter)
```

## Configuration

The SDK accepts the following configuration options:

- `token` (required): Your API connect token
- `onSuccess` (optional): Callback function called when connect completed successfully
- `onError` (optional): Callback function called when error occurs in the connect flow
- `onExit` (optional): Callback function called when the user exits the connect flow
- `onEvent` (optional): Callback function for handling various events
