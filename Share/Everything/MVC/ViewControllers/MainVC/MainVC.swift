//
//  MainVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fbIndicator: UIView!
    @IBOutlet weak var InstaIndicator: UIView!
    @IBOutlet weak var twitterIndicator: UIView!
    @IBOutlet weak var tumblrIndicator: UIView!
    
    enum social:Int {
        case facebook = 0
        case instagram
        case twitter
        case tumblr
        case vine
        case snapchat
    }
    let viewControllerIdentifiers = ["facebook","instagram","twitter","tumblr"]
    var facebookVC:UIViewController!
    var instagramVC:UIViewController!
    var twitterVC:UIViewController!
    var tumblrVC:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setIndicatorColor(social.facebook.rawValue)
        facebookVC =  (storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[0]))! as UIViewController
        instagramVC =  (storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[1]))! as UIViewController
        twitterVC =  (storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[2]))! as UIViewController
        tumblrVC =  (storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[3]))! as UIViewController
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        changeChildView(social.facebook.rawValue)
        setIndicatorColor(social.facebook.rawValue)
    }
   
    @IBAction func btnTwitterClicked(_ sender: Any) {
        changeChildView(social.twitter.rawValue)
        setIndicatorColor(social.twitter.rawValue)
    }
    @IBAction func btnInstaClicked(_ sender: AnyObject) {
        changeChildView(social.instagram.rawValue)
        setIndicatorColor(social.instagram.rawValue)
    }

    @IBAction func btnTumblrClicked(_ sender: AnyObject) {
        changeChildView(social.tumblr.rawValue)
        setIndicatorColor(social.tumblr.rawValue)
    }
    
    func changeChildView(_ tag:Int) {
        var newController:UIViewController!
        
        switch (tag) {
        case 0:
            newController = facebookVC
            break
        case 1:
            newController = instagramVC
            break
        case 2:
            newController = twitterVC
            break
        case 3:
            newController = tumblrVC
            break
        default:
            break
        }
        
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
  
    func setIndicatorColor(_ tag:Int)
    {
        fbIndicator.backgroundColor=UIColor.white
        InstaIndicator.backgroundColor=UIColor.white
        twitterIndicator.backgroundColor=UIColor.white
        tumblrIndicator.backgroundColor=UIColor.white
        switch tag {
        case 0:
            fbIndicator.backgroundColor=UIColor.init(red: 59.0/255, green: 89.0/255, blue: 152.0/255, alpha: 1)
            break
        case 1:
            InstaIndicator.backgroundColor=UIColor.init(red: 138.0/255, green: 58.0/255, blue: 185.0/255, alpha: 1)
            break
        case 2:
            twitterIndicator.backgroundColor=UIColor.init(red: 0/255, green: 172.0/255, blue: 237.0/255, alpha: 1)
            break
        case 3:
            tumblrIndicator.backgroundColor=UIColor.init(red: 50.0/255, green: 80.0/255, blue: 109.0/255, alpha: 1)
            break
        default: break
            
        }
    }
    
}


