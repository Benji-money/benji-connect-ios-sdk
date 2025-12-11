# Benji Connect iOS SDK

The Benji Connect iOS SDK provides a seamless way to integrate Benji's financial account connection capabilities into your iOS application. This SDK is a native Swift wrapper around the Benji Connect web interface, offering a native iOS experience with full Objective-C compatibility.

## Features

- ✅ **Native Swift SDK** with full Objective-C compatibility
- ✅ **Swift Package Manager** support for easy integration
- ✅ **WebView wrapper** around the Benji Connect web interface
- ✅ **Delegate-based callbacks** for handling events
- ✅ **Type-safe configuration** with BenjiConnectConfig
- ✅ **Comprehensive event handling** for all connection flow stages
- ✅ **Debug mode** for easier development and troubleshooting

## Requirements

- iOS 12.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Benji-money/benji-connect-ios-sdk.git", from: "1.0.0")
]
```

Or in Xcode:
1. File > Add Packages...
2. Enter the repository URL: `https://github.com/Benji-money/benji-connect-ios-sdk`
3. Select version and add to your project

## Usage

### Swift

```swift
import BenjiConnect

class ViewController: UIViewController {
    
    private var benjiConnect: BenjiConnect?
    
    func setupBenjiConnect() {
        // Create configuration
        let config = BenjiConnectConfig(
            clientId: "your-client-id",
            environment: "sandbox",
            userId: "user-123",
            debugMode: true
        )
        
        // Initialize BenjiConnect
        benjiConnect = BenjiConnect(config: config)
        benjiConnect?.delegate = self
    }
    
    func showBenjiConnect() {
        benjiConnect?.present(from: self, animated: true)
    }
}

// MARK: - BenjiConnectDelegate

extension ViewController: BenjiConnectDelegate {
    
    func benjiConnectDidLoad(_ benjiConnect: BenjiConnect) {
        print("Benji Connect loaded successfully")
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSucceedWithData data: [String: Any]) {
        print("Success! Data: \(data)")
        benjiConnect.dismiss()
    }
    
    func benjiConnectDidExit(_ benjiConnect: BenjiConnect) {
        print("User exited Benji Connect")
        benjiConnect.dismiss()
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSelectAccountWithData data: [String: Any]) {
        print("Account selected: \(data)")
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSelectInstitutionWithData data: [String: Any]) {
        print("Institution selected: \(data)")
    }
}
```

### Objective-C

```objc
#import <BenjiConnect/BenjiConnect-Swift.h>

@interface ViewController () <BenjiConnectDelegate>
@property (nonatomic, strong) BenjiConnect *benjiConnect;
@end

@implementation ViewController

- (void)setupBenjiConnect {
    // Create configuration
    BenjiConnectConfig *config = [[BenjiConnectConfig alloc] 
        initWithClientId:@"your-client-id"
        environment:@"sandbox"
        userId:@"user-123"
        metadata:nil
        baseURL:@"https://connect.benji.money"
        debugMode:YES];
    
    // Initialize BenjiConnect
    self.benjiConnect = [[BenjiConnect alloc] initWithConfig:config];
    self.benjiConnect.delegate = self;
}

- (void)showBenjiConnect {
    [self.benjiConnect presentFrom:self animated:YES completion:nil];
}

// MARK: - BenjiConnectDelegate

- (void)benjiConnectDidLoad:(BenjiConnect *)benjiConnect {
    NSLog(@"Benji Connect loaded successfully");
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didSucceedWithData:(NSDictionary<NSString *, id> *)data {
    NSLog(@"Success! Data: %@", data);
    [benjiConnect dismissWithAnimated:YES completion:nil];
}

- (void)benjiConnectDidExit:(BenjiConnect *)benjiConnect {
    NSLog(@"User exited Benji Connect");
    [benjiConnect dismissWithAnimated:YES completion:nil];
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

@end
```

## API Reference

### BenjiConnectConfig

Configuration object for initializing the SDK.

**Properties:**
- `clientId: String` - Your Benji client ID (required)
- `environment: String` - Environment to connect to: "production", "sandbox", or "development"
- `userId: String?` - Optional user identifier
- `metadata: [String: Any]?` - Optional metadata to pass to the web interface
- `baseURL: String` - Base URL for Benji Connect (default: "https://connect.benji.money")
- `debugMode: Bool` - Enable debug logging (default: false)

### BenjiConnect

Main SDK class for managing the connection flow.

**Methods:**
- `init(config: BenjiConnectConfig)` - Initialize with configuration
- `present(from:animated:completion:)` - Present the Benji Connect interface
- `dismiss(animated:completion:)` - Dismiss the interface
- `reload()` - Reload the web interface

**Properties:**
- `delegate: BenjiConnectDelegate?` - Delegate for receiving events
- `config: BenjiConnectConfig` - The configuration used to initialize

### BenjiConnectDelegate

Delegate protocol for receiving events (all methods are optional).

**Methods:**
- `benjiConnectDidLoad(_:)` - Called when the interface has loaded
- `benjiConnect(_:didSucceedWithData:)` - Called on successful connection
- `benjiConnectDidExit(_:)` - Called when user exits the flow
- `benjiConnect(_:didFailWithError:)` - Called when an error occurs
- `benjiConnect(_:didSelectAccountWithData:)` - Called when account is selected
- `benjiConnect(_:didSelectInstitutionWithData:)` - Called when institution is selected
- `benjiConnect(_:didReceiveEvent:)` - Called for any event (general handler)

### BenjiConnectEvent

Event object containing event type and associated data.

**Properties:**
- `type: BenjiConnectEventType` - The type of event
- `data: [String: Any]?` - Optional data associated with the event
- `error: Error?` - Optional error if the event is an error

**Event Types:**
- `.loaded` - SDK is ready
- `.success` - Connection successful
- `.exit` - User exited the flow
- `.error` - An error occurred
- `.accountSelected` - Account was selected
- `.institutionSelected` - Institution was selected
- `.custom` - Custom event type

### Error Handling

The SDK uses `BenjiConnectError` for creating standardized errors.

**Error Codes:**
- `.configurationError` (1000) - Configuration-related errors
- `.networkError` (1001) - Network-related errors
- `.invalidResponse` (1002) - Invalid server response
- `.userCancelled` (1003) - User cancelled the operation
- `.unknown` (9999) - Unknown error

## Example Project

Check out the `Examples` directory for a complete sample application demonstrating the SDK integration.

## Support

For questions, issues, or feature requests, please visit:
- GitHub Issues: https://github.com/Benji-money/benji-connect-ios-sdk/issues
- Documentation: https://docs.benji.money

## License

Copyright © 2025 Benji. All rights reserved.

This SDK is private and intended for use by authorized partners only.