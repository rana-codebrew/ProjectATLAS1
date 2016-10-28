//
//  MainVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    enum social:Int {
        case facebook = 0
        case instagram
        case twitter
        case tumblr
        case vine
        case snapchat
    }
    let viewControllerIdentifiers = ["facebook","","twitter",""]
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        changeChildView(social.facebook.rawValue)
    }
   
    @IBAction func btnTwitterClicked(_ sender: Any) {
        changeChildView(social.twitter.rawValue)
    }
    @IBAction func btnInstaClicked(_ sender: AnyObject) {
        changeChildView(social.instagram.rawValue)
    }

    @IBAction func btnTumblrClicked(_ sender: AnyObject) {
      //  changeChildView(social.tumblr.rawValue)
    }
    
    func changeChildView(_ tag:Int) {
        let newController = (storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[tag]))! as UIViewController
        let oldController = childViewControllers.last! as UIViewController
        
        oldController.willMove(toParentViewController: nil)
        addChildViewController(newController)
        newController.view.frame = oldController.view.frame
        
        transition(from: oldController, to: newController, duration: 0.25, options: .transitionCrossDissolve, animations:{ () -> Void in
            }, completion: { (finished) -> Void in
                oldController.removeFromParentViewController()
                newController.didMove(toParentViewController: self)
        })
    }
  
    
}


