# BenjiConnect iOS SDK Examples

This directory contains example implementations of the BenjiConnect iOS SDK in both Swift and Objective-C.

## Files

- **SwiftExample.swift** - Complete Swift example with UI
- **ObjectiveCExample.m** - Complete Objective-C example with UI

## How to Use

### Swift Example

1. Copy `SwiftExample.swift` into your Xcode project
2. Replace `"your-client-id-here"` with your actual Benji client ID
3. Update the environment if needed ("sandbox", "production", or "development")
4. Present the `ExampleViewController` in your app

```swift
let exampleVC = ExampleViewController()
navigationController?.pushViewController(exampleVC, animated: true)
```

### Objective-C Example

1. Copy `ObjectiveCExample.m` into your Xcode project
2. Ensure your bridging header includes BenjiConnect:
   ```objc
   #import <BenjiConnect/BenjiConnect-Swift.h>
   ```
3. Replace `@"your-client-id-here"` with your actual Benji client ID
4. Update the environment if needed
5. Present the `ExampleViewController` in your app

```objc
ExampleViewController *exampleVC = [[ExampleViewController alloc] init];
[self.navigationController pushViewController:exampleVC animated:YES];
```

## Key Features Demonstrated

Both examples demonstrate:

- ✅ SDK initialization with configuration
- ✅ Delegate implementation for all callbacks
- ✅ Presenting the BenjiConnect interface
- ✅ Handling success events
- ✅ Handling exit/cancellation
- ✅ Error handling
- ✅ Institution and account selection events
- ✅ UI updates based on SDK events
- ✅ Debug logging

## Testing

To test these examples:

1. Ensure you have valid Benji credentials
2. Use the "sandbox" environment for testing
3. Run the app on a physical device or iOS Simulator
4. Tap "Connect Account" to launch BenjiConnect
5. Follow the connection flow
6. Observe the status label updates and console logs

## Notes

- The examples use simple UI implementations for clarity
- In production, customize the UI to match your app's design
- Consider handling loading states and errors more gracefully
- The auto-dismiss on success can be removed if you want to handle navigation differently
- Debug mode is enabled in examples - disable it in production for cleaner logs
