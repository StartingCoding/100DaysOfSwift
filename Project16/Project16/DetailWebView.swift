//
//  DetailWebView.swift
//  Project16
//
//  Created by Loris on 5/13/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import WebKit
import UIKit

class DetailWebView: UIViewController, WKNavigationDelegate {
    @IBOutlet var detailWebView: WKWebView!
    var city = ""
    
    override func loadView() {
        detailWebView = WKWebView()
        detailWebView.navigationDelegate = self
        view = detailWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wikiUrl = "https://en.wikipedia.org/wiki/"
        
        if city == "Washington DC" {
            city = "Washington,_D.C."
        }
        
        let url = URL(string: wikiUrl + city)!
        detailWebView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}
