import XCTest
@testable import BenjiConnect

final class BenjiConnectTests: XCTestCase {
    
    func testConfigInitialization() {
        let config = BenjiConnectConfig(
            clientId: "test-client-id",
            environment: "sandbox"
        )
        
        XCTAssertEqual(config.clientId, "test-client-id")
        XCTAssertEqual(config.environment, "sandbox")
        XCTAssertEqual(config.baseURL, "https://connect.benji.money")
        XCTAssertFalse(config.debugMode)
    }
    
    func testConfigWithAllParameters() {
        let metadata = ["key": "value"]
        let config = BenjiConnectConfig(
            clientId: "test-client-id",
            environment: "production",
            userId: "user123",
            metadata: metadata,
            baseURL: "https://custom.url",
            debugMode: true
        )
        
        XCTAssertEqual(config.clientId, "test-client-id")
        XCTAssertEqual(config.environment, "production")
        XCTAssertEqual(config.userId, "user123")
        XCTAssertNotNil(config.metadata)
        XCTAssertEqual(config.baseURL, "https://custom.url")
        XCTAssertTrue(config.debugMode)
    }
    
    func testConfigBuildURL() {
        let config = BenjiConnectConfig(
            clientId: "test-client-id",
            environment: "sandbox"
        )
        
        let url = config.buildURL()
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("clientId=test-client-id") ?? false)
        XCTAssertTrue(url?.absoluteString.contains("environment=sandbox") ?? false)
    }
    
    func testConfigBuildURLWithUserId() {
        let config = BenjiConnectConfig(
            clientId: "test-client-id",
            environment: "sandbox",
            userId: "user123"
        )
        
        let url = config.buildURL()
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("userId=user123") ?? false)
    }
    
    func testBenjiConnectInitialization() {
        let config = BenjiConnectConfig(
            clientId: "test-client-id",
            environment: "sandbox"
        )
        
        let benjiConnect = BenjiConnect(config: config)
        XCTAssertEqual(benjiConnect.config.clientId, "test-client-id")
        XCTAssertEqual(benjiConnect.config.environment, "sandbox")
    }
    
    func testBenjiConnectConvenienceInitializer() {
        let benjiConnect = BenjiConnect(clientId: "test-client-id", environment: "sandbox")
        XCTAssertEqual(benjiConnect.config.clientId, "test-client-id")
        XCTAssertEqual(benjiConnect.config.environment, "sandbox")
    }
    
    func testEventInitialization() {
        let event = BenjiConnectEvent(type: .loaded)
        XCTAssertEqual(event.type, .loaded)
        XCTAssertNil(event.data)
        XCTAssertNil(event.error)
    }
    
    func testEventWithData() {
        let data = ["key": "value"]
        let event = BenjiConnectEvent(type: .success, data: data)
        XCTAssertEqual(event.type, .success)
        XCTAssertNotNil(event.data)
    }
    
    func testErrorCreation() {
        let error = BenjiConnectError.error(code: .configurationError, message: "Test error")
        XCTAssertEqual(error.domain, "com.benji.connect")
        XCTAssertEqual(error.code, 1000)
        XCTAssertEqual(error.localizedDescription, "Test error")
    }
}
