import UIKit
import BenjiConnect

/// Example demonstrating BenjiConnect SDK integration in Swift
class ExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    private var benjiConnect: BenjiConnect?
    private let connectButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBenjiConnect()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Benji Connect Example"
        
        // Setup connect button
        connectButton.setTitle("Connect Account", for: .normal)
        connectButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)
        
        // Setup status label
        statusLabel.text = "Ready to connect"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .gray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBenjiConnect() {
        // Create configuration with your credentials
        let config = BenjiConnectConfig(
            clientId: "your-client-id-here",
            environment: "sandbox",
            userId: "example-user-123",
            metadata: [
                "customData": "example value",
                "source": "ios-example"
            ],
            debugMode: true
        )
        
        // Initialize BenjiConnect
        benjiConnect = BenjiConnect(config: config)
        benjiConnect?.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func connectButtonTapped() {
        statusLabel.text = "Opening Benji Connect..."
        benjiConnect?.present(from: self, animated: true)
    }
}

// MARK: - BenjiConnectDelegate

extension ExampleViewController: BenjiConnectDelegate {
    
    func benjiConnectDidLoad(_ benjiConnect: BenjiConnect) {
        print("✅ Benji Connect loaded successfully")
        statusLabel.text = "Benji Connect loaded"
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSucceedWithData data: [String: Any]) {
        print("✅ Success! Data: \(data)")
        statusLabel.text = "Account connected successfully!"
        statusLabel.textColor = .systemGreen
        
        // Auto-dismiss after success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            benjiConnect.dismiss()
        }
    }
    
    func benjiConnectDidExit(_ benjiConnect: BenjiConnect) {
        print("👋 User exited Benji Connect")
        statusLabel.text = "Connection cancelled"
        statusLabel.textColor = .gray
        benjiConnect.dismiss()
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didFailWithError error: Error) {
        print("❌ Error: \(error.localizedDescription)")
        statusLabel.text = "Error: \(error.localizedDescription)"
        statusLabel.textColor = .systemRed
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSelectAccountWithData data: [String: Any]) {
        print("🏦 Account selected: \(data)")
        statusLabel.text = "Account selected"
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didSelectInstitutionWithData data: [String: Any]) {
        print("🏛️ Institution selected: \(data)")
        statusLabel.text = "Institution selected"
    }
    
    func benjiConnect(_ benjiConnect: BenjiConnect, didReceiveEvent event: BenjiConnectEvent) {
        print("📫 Event received: \(event.type)")
    }
}
