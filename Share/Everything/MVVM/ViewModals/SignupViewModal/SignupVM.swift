//
//  SignupVM.swift
//  Share
//
//  Created by Aseem 14 on 15/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignupVM {
    
    let btnR:UIButton
    let obj:UIViewController
    
    init(btnRemember: UIButton , VCObj: UIViewController) {
        btnR=btnRemember
        obj=VCObj
        
    }
    
   
    
    func btnRememberClicked(){
        switch btnR.tag {
        case 0:
            btnR.setImage(UIImage(named:"ic_check"), for: UIControlState.normal)
            btnR.tag=1
            break
        case 1:
            btnR.setImage(UIImage(named:"ic_unchecked_mark_FB"), for: UIControlState.normal)
            btnR.tag=0
            break
        default:
            break
            
        }
    }
    
    func btnCreateAccountClicked()
    {
        obj.performSegue(withIdentifier: "segueMain", sender: obj)
    }
    
    func btnLoginClicked()
    {
        _ = obj.navigationController?.popViewController(animated: true)
    }
    
    func endEditing()
    {
        obj.view.endEditing(true)
    }
    
    
}
