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
      
        //Email Textfiled Binding
        tfCollection[txtType.txtEmail.rawValue].rx.text
            .bindTo((viewModel?.emailText)!).addDisposableTo(disposeBag)
        
        //Password Textfield Binding
        tfCollection[txtType.txtPassword.rawValue].rx.text
            .bindTo((viewModel?.passwrodText)!).addDisposableTo(disposeBag)
        
        //Remember Button Binfing
        btnRemember.rx.tap.subscribe(onNext: { _ in
          self.viewModel?.btnRememberClicked()
        }).addDisposableTo(disposeBag)
        
        //Create button Binding
        btnCreateAccount.rx.tap.subscribe(onNext:{ _ in
          self.viewModel?.btnCreateAccClicked()
            }).addDisposableTo(disposeBag)
        
        //Reset Password Button Binding
        btnResetPassword.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.forgotPasswordClikced()
        }).addDisposableTo(disposeBag)
        
        //Login Button Binding
        btnLogin.rx.tap.subscribe(onNext: { _ in
          self.viewModel?.login()
          }).addDisposableTo(disposeBag)
        
        //View touch Binding
        self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)
    }

}

