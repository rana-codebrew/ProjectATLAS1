//
//  LoginVM.swift
//  Share
//
//  Created by Aseem 14 on 14/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class LoginVM {

//MARK: - local Variables
  var emailText = Variable<String?>("")
  var passwrodText = Variable<String?>("")
  let provider: RxMoyaProvider<Share>
  let disposeBag = DisposeBag()
  var userTracker: UserTrackerModal!
  let LoginVCObj:LoginVC
  
//MARK: - Initializing ViewModel
  init(loginVCObj:LoginVC){
    LoginVCObj=loginVCObj
    if let remember = UserDefaults.standard.value(forKey: "share_user_remember") as? String {
        if remember == "1" {
            self.LoginVCObj.performSegue(withIdentifier: "segueMain", sender: LoginVCObj)
        }
    }
    self.provider = RxMoyaProvider<Share>()
    self.userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:self.provider)
    
  }
  
//MARK: - login
  func login(){
    
    self.LoginVCObj.activityIndicator.isHidden=false
    self.userTracker.validateLogin(email:emailText.value!, passwd: passwrodText.value!)
      .subscribe { event in
        switch event {
        case .next(let userMap):
          if(userMap?.UstatusCode == 200)
          {
            print(userMap?.UserData?.UaccessToken ?? "")
            if(self.LoginVCObj.btnRemember.tag==1)
            {
                UserDefaults.standard.setValue("1", forKey: "share_user_remember")
            }
            else
            {
                UserDefaults.standard.setValue("0", forKey: "share_user_remember")
            }
            self.LoginVCObj.performSegue(withIdentifier: "segueMain", sender: self.LoginVCObj)
            UserDefaults.standard.setValue(userMap?.UserData?.UaccessToken, forKey: "share_auth_token")
            UserDefaults.standard.setValue(userMap?.UserData?.userDetails?.name, forKey: "share_user_name")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          else
          {
            print(userMap?.Umessage ?? "Error Occured")
            self.LoginVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          break
        case .error(let error):
          print("Failed:",error.localizedDescription)
          self.LoginVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
          break
        default:break
        }
      }.addDisposableTo(self.disposeBag)
  }
  
//MARK: - Remember me
  func btnRememberClicked(){
    switch LoginVCObj.btnRemember.tag {
    case 0:
      LoginVCObj.btnRemember.setImage(UIImage(named:"ic_check"), for: UIControlState.normal)
      LoginVCObj.btnRemember.tag=1
      break
    case 1:
      LoginVCObj.btnRemember.setImage(UIImage(named:"ic_unchecked_mark_FB"), for: UIControlState.normal)
      LoginVCObj.btnRemember.tag=0
      break
    default:break
    }
  }
  
//MARK: - Forgot Password
  func forgotPasswordClikced(){
    self.LoginVCObj.activityIndicator.isHidden=false
    self.userTracker.forgotPass(email:self.emailText.value!)
      .subscribe { event in
        switch event {
        case .next(let userMap):
          if(userMap?.UstatusCode == 200)
          {
            self.LoginVCObj.presentError(title:"Success",message:"Check your email for password",okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          else
          {
            print(userMap?.Umessage ?? "Error Occured")
            self.LoginVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
            self.LoginVCObj.activityIndicator.isHidden=true
          }
          break
        case .error(let error):
          print("Failed:",error.localizedDescription)
          self.LoginVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
          break
        default:break
        }
      }.addDisposableTo(self.disposeBag)
  }
  
//MARK: - Create Account
  func btnCreateAccClicked() {
      _ = self.LoginVCObj.performSegue(withIdentifier: "segueCreateAcc", sender: self)
  }

}
