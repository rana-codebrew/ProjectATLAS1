//
//  IntegrateVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
class IntegrateVC: UIViewController {

    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCreateAccount.isHidden=true
    }

    @IBAction func btnFacebookClicked(_ sender: AnyObject) {
    }
    @IBAction func btnTwitterClicked(_ sender: AnyObject) {
    }
    
    
    @objc func facebookLogin() {
        
                self.btnFacebook.setImage(UIImage(named:"ic_check"), for: UIControlState.normal)
                self.btnCreateAccount.isHidden=false
    }
    
    @IBAction func btnCreateAccountClicked(_ sender: AnyObject) {
        performSegue(withIdentifier: "segueMain", sender: self)
    }
}
