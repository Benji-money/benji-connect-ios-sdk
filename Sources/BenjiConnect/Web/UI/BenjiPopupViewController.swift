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

    init(factory: BenjiWebViewFactory, configuration: WKWebViewConfiguration) {
        self.webView = factory.makeWebView(using: configuration)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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

        if let url = navigationAction.request.url, url.isOAuthURL {
            decisionHandler(.cancel)
            //startOAuthInSystemBrowser(url: url)
            return
        }

        decisionHandler(.allow)
    }
}

