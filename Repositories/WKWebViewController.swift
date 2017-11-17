//
//  WKWebViewController.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {

    var urlString: String?

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

        guard let urlString = self.urlString else { return }
        let tempUrl = URL(string: urlString)

        guard let url = tempUrl else { return }
        let request = URLRequest(url: url)

        webView.load(request)
    }

    // MARK: WKNavigationDelegate methods

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        let alert = UIAlertController.simpleAlert(text: error.localizedDescription)
        self.present(alert, animated: true)
    }
}
