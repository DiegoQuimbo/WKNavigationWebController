//
//  NavigationWebViewController.swift
//  NavigationWeb
//
//  Created by Diego Quimbo on 7/10/17.
//  Copyright © 2017 Diego Quimbo. All rights reserved.
//

import UIKit
import WebKit

public class NavigationWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    
    var webView : WKWebView!
    var URLConnect : URL!
    var toolbar : UIToolbar!

    public init(url:URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.URLConnect = url
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.initWebView()
        
        self.addWebViewObservers()
        
        self.addToolBar()
        
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeObserver(self, forKeyPath: "webView.title")
        self.removeObserver(self, forKeyPath: "webView.loading")
    }
    
    // MARK: -
    // MARK: - Private Functions
    
    func initWebView() {
        
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        self.view.addSubview(webView)
        
        let request = URLRequest(url: self.URLConnect)
        
        webView.load(request)
    }
    
    func addWebViewObservers() {
        
        self.addObserver(self, forKeyPath: "webView.title", options: NSKeyValueObservingOptions.new, context: nil)
        self.addObserver(self, forKeyPath: "webView.loading", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func addToolBar() {
        
        toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: self.view.frame.size.height - 46, width: self.view.frame.size.width, height: 46)
        toolbar.sizeToFit()
        self.view.addSubview(toolbar)
        
        self.fillToolbar()
    }
    
    func fillToolbar() {
        
        let backItem = UIBarButtonItem(image: UIImage(named:"back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped(sender:)))
        backItem.isEnabled = webView.canGoBack;
        
        let forwardItem = UIBarButtonItem(image: UIImage(named:"forward"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(forwardTapped(sender:)))
        forwardItem.isEnabled = webView.canGoForward;
        
        var reloadItem : UIBarButtonItem!
        if self.webView.isLoading {
            reloadItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(stopTapped(sender:)))
        }else{
            reloadItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(reloadTapped(sender:)))
        }
        
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleSpaceItem, backItem, flexibleSpaceItem, forwardItem, flexibleSpaceItem, reloadItem, flexibleSpaceItem]
    }

    
    // MARK: -
    // MARK: - Toolbar Actions
    
    func backTapped(sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    func forwardTapped(sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    func reloadTapped(sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    func stopTapped(sender: UIBarButtonItem) {
        self.webView.stopLoading()
    }
    
    // MARK: -
    // MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "webView.title" {
            if let titleValue = change?[.newKey] {
                self.title = titleValue as? String;
            }
        }else{
            if keyPath == "webView.loading"{
                self.fillToolbar()
            }
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        
        if authenticationMethod == NSURLAuthenticationMethodDefault || authenticationMethod == NSURLAuthenticationMethodHTTPBasic || authenticationMethod == NSURLAuthenticationMethodHTTPDigest || authenticationMethod == NSURLAuthenticationMethodNTLM {

            let alertController: UIAlertController = UIAlertController(title: "Authentication Required", message: "", preferredStyle: .alert)
            
            // Cancel button
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            })
            
            // Log In Button
            alertController.addAction(UIAlertAction(title: "Log In", style: .default) { action -> Void in
                
                
                // Get the credentials
                let textfields = alertController.textFields
                let nameField = textfields?[0]
                let passwordField = textfields?[1]
                
                guard let name = nameField?.text, let password = passwordField?.text, name != "", password != "" else {
                    completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                    return
                }
                
                let credential = URLCredential(user: name, password: password, persistence: URLCredential.Persistence.forSession)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            })
            
            // Add user text field
            alertController.addTextField { (textField) -> Void in
                textField.placeholder = "User"
            }
            
            // Add password text field
            alertController.addTextField { (textField) -> Void in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            
            //Present the AlertController
            present(alertController, animated: true, completion: nil)
            
        }else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }else{
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
        
    }

    
    
    // MARK: -
    // MARK: - WKUIDelegate
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        webView.load(navigationAction.request)
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
