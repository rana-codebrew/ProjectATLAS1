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
  
//MARK: - local Variables
    let disposeBag = DisposeBag()
    var viewModel:LoginVM?
    enum txtType:Int {
      case txtEmail = 0
      case txtPassword = 1
    }
  
//MARK: - Outlets
  @IBOutlet var tfCollection: [UITextField]!{
    didSet{
      tfCollection.forEach{
          $0.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
      }
    }
  }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var responseTxt: UILabel!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnResetPassword: UIButton!
  
//MARK: - DidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginVM(loginVCObj: self)
        bindingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
  
//MARK: - BindingUI
    
    func bindingUI(){
      
        tfCollection[txtType.txtEmail.rawValue].rx.text.bindTo((viewModel?.emailText)!).addDisposableTo(disposeBag)
        tfCollection[txtType.txtPassword.rawValue].rx.text.bindTo((viewModel?.passwrodText)!).addDisposableTo(disposeBag)
      
//        btnTap(btnTap: btnRemember, selector: (self.viewModel?.btnRememberClicked())!)
//        btnTap(btnTap: btnCreateAccount, selector: (self.viewModel?.btnCreateAccClicked())!)
//        btnTap(btnTap: btnResetPassword, selector: (self.viewModel?.forgotPasswordClikced())!)

        
        
        btnRemember.rx.tap.subscribe(onNext: { _ in
          self.viewModel?.btnRememberClicked()
        }).addDisposableTo(disposeBag)
        
        btnCreateAccount.rx.tap.subscribe(onNext:{ _ in
          self.viewModel?.btnCreateAccClicked()
            }).addDisposableTo(disposeBag)
        
        btnResetPassword.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.forgotPasswordClikced()
        }).addDisposableTo(disposeBag)
        
        btnLogin.rx.tap.subscribe(onNext: { _ in
          self.viewModel?.login()
          }).addDisposableTo(disposeBag)
        
        self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)
    }
    
    
//    func btnTap (btnTap : UIButton,selector : ()){
//
//        btnTap.rx.tap.subscribe(onNext: { _ in
//            selector
//        }).addDisposableTo(disposeBag)
//    }

}

