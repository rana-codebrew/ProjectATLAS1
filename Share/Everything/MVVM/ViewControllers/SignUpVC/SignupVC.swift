//
//  SignupVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Moya_ModelMapper
class SignupVC: UIViewController {

    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    
    @IBOutlet var tfCollection: [UITextField]!{
        didSet{
            tfCollection.forEach{
                $0.layer.borderColor=UIColor.groupTableViewBackground.cgColor
                $0.layer.borderWidth=1
                $0.layer.sublayerTransform=CATransform3DMakeTranslation(7, 0, 0)
            }
        }

    }
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
    }
    
    func bindingUI()  {
        
         self.view.rx.sentMessage(#selector(UIView.touchesBegan)).subscribe (onNext:{_ in self.view.endEditing(true)}).addDisposableTo(disposeBag)
        
        
         btnCreateAccount.rx.tap.subscribe(onNext:{ _ in
            self.activityIndicator.isHidden=false
            self.provider = RxMoyaProvider<Share>()
            self.userTracker = UserTrackerModal(provider: self.provider)
            self.userTracker.registerUser(name: self.tfCollection[0].text!, email: self.tfCollection[1].text!, passwd: self.tfCollection[2].text!)
                .subscribe { event in
                    switch event {
                    case .next(let userMap):
                        if(userMap?.UstatusCode == 201)
                        {
                            print(userMap?.UserData?.UaccessToken)
                            self.performSegue(withIdentifier: "segueMain", sender: self)
                            UserDefaults.standard.setValue(userMap?.UserData?.UaccessToken, forKey: "share_auth_token")
                            UserDefaults.standard.setValue(userMap?.UserData?.name, forKey: "share_user_name")
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
        
         btnLogin.rx.tap.subscribe(onNext:{ _ in  _ = self.navigationController?.popViewController(animated: true)}).addDisposableTo(disposeBag)
    }
}
