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
    var viewModel:SettingsVM?
    enum txtType:Int {
        case txtName = 0
        case txtNewPass = 1
    }
    
    
    @IBOutlet weak var btnSaveName: UIButton!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnResetGraph: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet var tfCollection: [TextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsVM(settingsVCObj: self)
        bindingUI()
    }
    
    func bindingUI(){
        
        tfCollection[txtType.txtName.rawValue].rx.text.bindTo((viewModel?.name)!).addDisposableTo(disposeBag)
        
        
        tfCollection[txtType.txtNewPass.rawValue].rx.text.bindTo((viewModel?.newPassword)!).addDisposableTo(disposeBag)
        
        btnSaveName.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.saveName()
        }).addDisposableTo(disposeBag)
        
        btnChangePass.rx.tap.subscribe(onNext: {_ in
            self.viewModel?.chnagePassword()
        }).addDisposableTo(disposeBag)
        
        btnResetGraph.rx.tap.subscribe(onNext: {_ in
            self.viewModel?.resetGraph()
        }).addDisposableTo(disposeBag)
        
        btnLogout.rx.tap.subscribe(onNext:{_ in
            UserDefaults.standard.setValue("0", forKey: "share_user_remember")
            _ = self.navigationController?.popToRootViewController(animated: true)
        }).addDisposableTo(disposeBag)
    }

    @IBAction func btnBackClicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
