//
//  ViewController.swift
//  Project31
//
//  Created by Wbert Castro on 23/08/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var activeWebView: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func addWebView() {
        let webView = UIWebView()
        webView.delegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://hackingwithswift.com")!
        
        webView.loadRequest(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    func selectWebView(_ webView: UIWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
    }
    
    func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.loadRequest(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func deleteWebView() {
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.index(of: webView) {
                stackView.removeArrangedSubview(webView)
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                } else {
                    var currentIndex = Int(index)
                    
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? UIWebView {
                        selectWebView(newSelectedWebView)
                        updateUI(for: newSelectedWebView)
                    }
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    func updateUI(for webView: UIWebView) {
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
        addressBar.text = webView.request?.url?.absoluteString ?? ""
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
}
