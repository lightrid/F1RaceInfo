//
//  WebViewController.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var urlString: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }

    private func loadWebView() {
        guard let url = URL(string: urlString) else {
            AlertMessage.showAlert(title: "Warning", message: "Invalid URL", controller: self)
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}
