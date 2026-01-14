//
//  BenjiPopupViewController.swift
//  BenjiConnect
//
//  Created by Marta Wilgan on 12/16/25.
//

import AuthenticationServices
import UIKit
import WebKit

@MainActor
final class BenjiPopupWebViewController: UIViewController {

    let webView: WKWebView
    var onClose: (() -> Void)?

    init(
        configuration: WKWebViewConfiguration,
        factory: BenjiWebViewFactory
    ) {
        self.webView = factory.makeWebView(using: configuration)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sheet = presentationController as? UISheetPresentationController {
            sheet.detents = [.large()]
            sheet.selectedDetentIdentifier = .large
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }

        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.endEditing(true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
        onClose?()
    }
}

extension BenjiPopupWebViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? ASPresentationAnchor()
    }
}

extension BenjiPopupWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension BenjiPopupWebViewController: WKUIDelegate {
    
    // Dismiss Popup when navigating away in Connect JS
    func webViewDidClose(_ webView: WKWebView) {
        dismiss(animated: true)
        onClose?()
    }
}

