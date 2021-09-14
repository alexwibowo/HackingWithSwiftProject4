//
//  ViewController.swift
//  HwSwiftProj4
//
//  Created by Alex Wibowo on 14/9/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    var initialWeb = Bookmark.urls[0]
    
    override func loadView() {
        webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view = webView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(goToURL))
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = false
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        toolbarItems = [
            UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack)),
            UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward)),
            UIBarButtonItem(customView: progressView),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Reload", style: .plain, target: webView, action: #selector(webView.reload))
        ]
        
        
        
        
        if let url = URL(string: "https://\(initialWeb)") {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc func goToURL(){
        let uac = UIAlertController(title: "Go to", message: nil, preferredStyle: .alert)
        
        uac.addTextField()
        uac.addAction(UIAlertAction(title: "Go", style: .default, handler: { [weak webView] action in
            guard let urlString = uac.textFields?[0].text else { return }
            if let url = URL(string: urlString) {
                webView?.load(URLRequest(url: url))
            }
            
        }))
        present(uac, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = webView.url else { decisionHandler(.cancel); return }
        
        if let host = url.host {
            for bookmark in Bookmark.urls {
                if (host.contains(bookmark)){
                    decisionHandler(.allow)
                    return
                }
            }
        }
    
        let uac = UIAlertController(title: "Blocked", message: "That website is not allowed", preferredStyle: .alert)
        uac.addAction(UIAlertAction(title: "OK", style: .default))
        present(uac, animated: true)
        decisionHandler(.cancel)
    }
    


}

