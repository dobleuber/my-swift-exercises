//
//  DetailViewController.swift
//  Challenge6
//
//  Created by Wbert Castro on 16/07/17.
//  Copyright © 2017 Wbert Castro. All rights reserved.
//

import UIKit
import WebKit

class DetailTableViewController: UIViewController {
    var country: Country!
    var webView: WKWebView!

    override func loadView() {
        super.loadView()
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard country != nil else {
            return
        }
        
        var body = "<h5>\(country.name)</h5>"
        body += "<img src='\(country.flag)' style='width:132px;height:88px'>"
        body += "<table width='100%'>"
        body += "<tr><td>Capital</td><td>\(country.capital)</td></tr>"
        body += "<tr><td>Region</td><td>\(country.region)</td></tr>"
        body += "<tr><td>Population</td><td>\(country.population)</td></tr>"
        body += "<tr><td>Demonym</td><td>\(country.demonym)</td></tr>"
        body += "</table>"
        
        
        var html = "<html>"
        html += "<head>"
        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        html += "<style> body { font-size: 150%; } </style>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        webView.loadHTMLString(html, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
