//
//  DetailViewController.swift
//  Project 7
//
//  Created by Eduard Tokarev on 03.01.2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        
        let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<h2> \(detailItem.title) </h2>
<p> \(detailItem.body) </p>

<hr></hr>
<p> Signature count: \(detailItem.signatureCount). </p>

</body>
</html>
"""
//        <style> body { font-size: 150%; } </style>
        webView.loadHTMLString(html, baseURL: nil)
    }
    

}
