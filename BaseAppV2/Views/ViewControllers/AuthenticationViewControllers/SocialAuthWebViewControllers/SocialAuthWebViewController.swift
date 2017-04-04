//
//  SocialAuthWebViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/22/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import WebKit

/**
    A `BaseViewController` responsible for displaying
    a webview. The webview displays content related
    to OAuth authentication.
*/
final class SocialAuthWebViewController: BaseViewController {
    
    // MARK: - Private Instance Methods
    @objc fileprivate var webView: WKWebView!
    fileprivate var redirectUri: URL!
    fileprivate var oauthUrl: URL!
    
    
    // MARK: - Public Instance Attributes
    var redirectUrlWithQueryParametersRecievedClosure: ((_ redirectUrlWithQueryParameters: URL) -> Void)?
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `SocialAuthWebViewController`.
     
        - Parameters:
            - redirectUri: A `String` representing the redirect uri used
                           for a OAuth provider.
            - oauthUrl: A `URL` representing the url for performing
                        OAuth authentication.
    */
    init(redirectUri: String, oauthUrl: URL) {
        super.init(nibName: nil, bundle: nil)
        self.redirectUri = URL(string: redirectUri)!
        self.oauthUrl = oauthUrl
        setup()
    }
    
    /// Required initializer for Subclass.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Deinitializers
    
    /**
        Deinitializes an instance of `SocialAuthWebViewController`.
    */
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.load(URLRequest(url: oauthUrl))
    }
}


// MARK: - WKNavigationDelegate
extension SocialAuthWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let authorizationUrl = navigationAction.request.url, authorizationUrl.host == redirectUri.host else {
            decisionHandler(.allow)
            return
        }
        if let closure = redirectUrlWithQueryParametersRecievedClosure {
            closure(authorizationUrl)
            dismissView()
        }
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishProgressBar()
    }
}


// MARK: - Key Value Observer
extension SocialAuthWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            setProgressForNavigationBar(progress: Float(webView.estimatedProgress))
        }
    }
}


// MARK: - Private Instance Methods
fileprivate extension SocialAuthWebViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Miscellaneous.Cancel", comment: "Back Button"), style: .plain, target: self, action: #selector(dismissView))
        view = webView
    }
    
    /// Dismiss the view.
    @objc fileprivate func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
