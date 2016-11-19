//
//  WebViewVC.swift
//  Share
//
//  Created by Aseem 14 on 14/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    enum stringURL :String
    {
        case facebook = "http://m.facebook.com"
        case instagram = "https://www.instagram.com/?hl=en"
        case twitter = "https://mobile.twitter.com"
        case tumblr = "https://www.tumblr.com"
        case vine = "https://vine.co"
        case pintrest = "https://www.pinterest.com"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:String;
        
        switch (self.restorationIdentifier! as String) {
        case  "facebook":
            url=stringURL.facebook.rawValue
            break;
        case "instagram":
            url=stringURL.instagram.rawValue
            break
        case "twitter":
            url=stringURL.twitter.rawValue
            break
        case "tumblr":
            url=stringURL.tumblr.rawValue
            break
        case "vine":
            url=stringURL.vine.rawValue
            break
        case "pinterest":
            url=stringURL.pintrest.rawValue
            break
        default:
            url=""
            break
        }
        UIWebView.loadRequest(webView)(URLRequest(url: URL(string: url)!))
    }
    func webViewDidStartLoad(_ webView : UIWebView) {
        activityIndicator.isHidden=false;
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView){
        activityIndicator.isHidden=true;
    }


}
