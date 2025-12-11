#import <UIKit/UIKit.h>
#import <BenjiConnect/BenjiConnect-Swift.h>

/// Example demonstrating BenjiConnect SDK integration in Objective-C
@interface ExampleViewController : UIViewController <BenjiConnectDelegate>

@property (nonatomic, strong) BenjiConnect *benjiConnect;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupBenjiConnect];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Benji Connect Example";
    
    // Setup connect button
    self.connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.connectButton setTitle:@"Connect Account" forState:UIControlStateNormal];
    self.connectButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [self.connectButton addTarget:self action:@selector(connectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.connectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.connectButton];
    
    // Setup status label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"Ready to connect";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor grayColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.connectButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.connectButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.connectButton.bottomAnchor constant:20],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
}

- (void)setupBenjiConnect {
    // Create configuration with your credentials
    NSDictionary *metadata = @{
        @"customData": @"example value",
        @"source": @"ios-example"
    };
    
    BenjiConnectConfig *config = [[BenjiConnectConfig alloc]
        initWithClientId:@"your-client-id-here"
        environment:@"sandbox"
        userId:@"example-user-123"
        metadata:metadata
        baseURL:@"https://connect.benji.money"
        debugMode:YES];
    
    // Initialize BenjiConnect
    self.benjiConnect = [[BenjiConnect alloc] initWithConfig:config];
    self.benjiConnect.delegate = self;
}

- (void)connectButtonTapped {
    self.statusLabel.text = @"Opening Benji Connect...";
    [self.benjiConnect presentFrom:self animated:YES completion:nil];
}

#pragma mark - BenjiConnectDelegate

- (void)benjiConnectDidLoad:(BenjiConnect *)benjiConnect {
    NSLog(@"✅ Benji Connect loaded successfully");
    self.statusLabel.text = @"Benji Connect loaded";
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didSucceedWithData:(NSDictionary<NSString *, id> *)data {
    NSLog(@"✅ Success! Data: %@", data);
    self.statusLabel.text = @"Account connected successfully!";
    self.statusLabel.textColor = [UIColor systemGreenColor];
    
    // Auto-dismiss after success
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [benjiConnect dismissWithAnimated:YES completion:nil];
    });
}

- (void)benjiConnectDidExit:(BenjiConnect *)benjiConnect {
    NSLog(@"👋 User exited Benji Connect");
    self.statusLabel.text = @"Connection cancelled";
    self.statusLabel.textColor = [UIColor grayColor];
    [benjiConnect dismissWithAnimated:YES completion:nil];
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didFailWithError:(NSError *)error {
    NSLog(@"❌ Error: %@", error.localizedDescription);
    self.statusLabel.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    self.statusLabel.textColor = [UIColor systemRedColor];
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didSelectAccountWithData:(NSDictionary<NSString *, id> *)data {
    NSLog(@"🏦 Account selected: %@", data);
    self.statusLabel.text = @"Account selected";
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didSelectInstitutionWithData:(NSDictionary<NSString *, id> *)data {
    NSLog(@"🏛️ Institution selected: %@", data);
    self.statusLabel.text = @"Institution selected";
}

- (void)benjiConnect:(BenjiConnect *)benjiConnect didReceiveEvent:(BenjiConnectEvent *)event {
    NSLog(@"📫 Event received: %ld", (long)event.type);
}

@end
