//
//  LoginVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift
class LoginVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
                txtEmail.layer.borderColor=UIColor.groupTableViewBackground.cgColor
                txtEmail.layer.borderWidth=1
                txtEmail.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
        }
    }
    @IBOutlet weak var txtPassword: UITextField!{
        didSet{
            txtPassword.layer.borderColor=UIColor.groupTableViewBackground.cgColor
            txtPassword.layer.borderWidth=1
            txtPassword.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var responseTxt: UILabel!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
    }
    
    func bindingUI(){
        self.provider = RxMoyaProvider<Share>()
        self.userTracker = UserTrackerModal(provider: self.provider)
        btnRemember.rx.tap.subscribe(onNext: { _ in
            if(self.btnRemember.tag==0)
            {
                self.btnRemember.setImage(UIImage(named:"ic_check"), for: UIControlState.normal)
                self.btnRemember.tag=1
            }
            else
            {
                self.btnRemember.setImage(UIImage(named:"ic_unchecked_mark_FB"), for: UIControlState.normal)
                self.btnRemember.tag=0
            }
            }).addDisposableTo(disposeBag)
        
        btnCreateAccount.rx.tap.subscribe(onNext:{ _ in
             self.performSegue(withIdentifier: "segueCreateAcc", sender: self)
            }).addDisposableTo(disposeBag)
        
        btnResetPassword.rx.tap.subscribe(onNext: { _ in
            self.activityIndicator.isHidden=false
            self.userTracker.forgotPass(email:self.txtEmail.text!)
                .subscribe { event in
                    switch event {
                    case .next(let userMap):
                        
                        if(userMap?.UstatusCode == 200)
                        {
                            self.presentError(title:"Success",message:"Check your email for password",okText:"OK")
                            self.activityIndicator.isHidden=true
                        }
                        else
                        {
                            print(userMap?.Umessage)
                            self.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                            self.activityIndicator.isHidden=true
                        }
                        break
                    case .error(let error):
                        print("Failed:",error.localizedDescription)
                        self.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                        break
                    default:break
                    }
                }.addDisposableTo(self.disposeBag)
        }).addDisposableTo(disposeBag)
        
        btnLogin.rx.tap.subscribe(onNext: { _ in
            self.activityIndicator.isHidden=false
            self.userTracker.validateLogin(email: self.txtEmail.text!, passwd: self.txtPassword.text!)
                .subscribe { event in
                    switch event {
                    case .next(let userMap):
                      
                        if(userMap?.UstatusCode == 200)
                        {
                            print(userMap?.UserData?.UaccessToken)
                            self.performSegue(withIdentifier: "segueMain", sender: self)
                            UserDefaults.standard.setValue(userMap?.UserData?.UaccessToken, forKey: "share_auth_token")
                            UserDefaults.standard.setValue(userMap?.UserData?.userDetails?.name, forKey: "share_user_name")
                            self.activityIndicator.isHidden=true
                        }
                        else
                        {
                            print(userMap?.Umessage)
                            self.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                            self.activityIndicator.isHidden=true
                        }
                        break
                    case .error(let error):
                        print("Failed:",error.localizedDescription)
                        self.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                        break
                    default:break
                    }
            }.addDisposableTo(self.disposeBag)
            }).addDisposableTo(disposeBag)
        
        self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)
    }
}

