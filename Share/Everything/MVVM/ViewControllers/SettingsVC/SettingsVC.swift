//
//  SettingsVC.swift
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


class SettingsVC: UIViewController {
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    
    @IBOutlet weak var txtName: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtOldPass: TextField!
    @IBOutlet weak var txtNewPass: TextField!

    @IBOutlet weak var btnSaveName: UIButton!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnResetGraph: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
    }
    
    func bindingUI(){
        self.provider = RxMoyaProvider<Share>()
        self.userTracker = UserTrackerModal(provider: self.provider)
        
        btnSaveName.rx.tap.subscribe(onNext: { _ in
          //  self.activityIndicator.isHidden=false
            self.userTracker.forgotPass(email:self.txtEmail.text!)
                .subscribe { event in
                    switch event {
                    case .next(let userMap):
                        
                        if(userMap?.UstatusCode == 200)
                        {
                            self.presentError(title:"Success",message:"Check your email for password",okText:"OK")
                          //  self.activityIndicator.isHidden=true
                        }
                        else
                        {
                            print(userMap?.Umessage)
                            self.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                         //   self.activityIndicator.isHidden=true
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
    }

    @IBAction func btnBackClicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
