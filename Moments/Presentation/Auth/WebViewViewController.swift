//
//  WebViewViewController.swift
//  Moments
//
//  Created by Alexey Ponomarev on 28.09.2023.
//
import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

private enum QueryKeys {
    static let clientId: String = "client_id"
    static let redirectUri: String = "redirect_uri"
    static let responseType: String = "response_type"
    static let scope: String = "scope"
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    // KVO new API
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        
        // KVO new API
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    
    private func code(from navigationAction: WKNavigationAction) -> String?  {
        guard let url = navigationAction.request.url else { return nil }
        return presenter?.code(from: url)
    }
}

extension WebViewViewController {
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}
