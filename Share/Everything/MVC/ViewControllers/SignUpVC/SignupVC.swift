//
//  SignupVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRemember: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI()  {
        txtEmail.layer.borderColor=UIColor.groupTableViewBackground.cgColor
        txtPassword.layer.borderColor=UIColor.groupTableViewBackground.cgColor
        txtEmail.layer.borderWidth=1
        txtPassword.layer.borderWidth=1
        txtEmail.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
        txtPassword.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
    }
    

    @IBAction func btnRememberClicked(_ sender: AnyObject) {
        if(btnRemember.tag==0)
        {
            btnRemember.setImage(UIImage(named:"ic_check"), for: UIControlState.normal)
            btnRemember.tag=1
        }
        else
        {
            btnRemember.setImage(UIImage(named:"ic_unchecked_mark_FB"), for: UIControlState.normal)
            btnRemember.tag=0
        }
    }
    @IBAction func btnLoginClicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateAccountClicked(_ sender: AnyObject) {
        performSegue(withIdentifier: "segueIntegrate", sender: self)
    }
}
