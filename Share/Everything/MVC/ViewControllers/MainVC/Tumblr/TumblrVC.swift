//
//  TumblrVC.swift
//  Share
//
//  Created by Aseem 14 on 31/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class TumblrVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIWebView.loadRequest(webView)(URLRequest(url: URL(string: "https://www.tumblr.com")!))
    }
    func webViewDidStartLoad(_ webView : UIWebView) {
        activityIndicator.isHidden=false;
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView){
        activityIndicator.isHidden=true;
    }
}
