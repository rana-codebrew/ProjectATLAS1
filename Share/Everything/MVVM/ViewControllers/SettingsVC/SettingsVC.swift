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
    
//MARK: - local Variables
    let disposeBag = DisposeBag()
    var viewModel:SettingsVM?
    enum txtType:Int {
        case txtName = 0
        case txtNewPass = 1
    }
    
//MARK: - Outlets    
    @IBOutlet weak var btnSaveName: UIButton!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnResetGraph: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet var tfCollection: [TextField]!
    
//MARK: - DidLoad Function    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsVM(settingsVCObj: self)
        bindingUI()
    }
    
//MARK: - BindingUI
    func bindingUI(){
        
        //Binding Username text
        tfCollection[txtType.txtName.rawValue].rx.text.bindTo((viewModel?.name)!).addDisposableTo(disposeBag)
        
        //Binding Password Text
        tfCollection[txtType.txtNewPass.rawValue].rx.text.bindTo((viewModel?.newPassword)!).addDisposableTo(disposeBag)
        
        //Binding Save button
        btnSaveName.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.saveName()
        }).addDisposableTo(disposeBag)
        
        //Binding Change password Button
        btnChangePass.rx.tap.subscribe(onNext: {_ in
            self.viewModel?.chnagePassword()
        }).addDisposableTo(disposeBag)
        
        //Binding reset Graph Button
        btnResetGraph.rx.tap.subscribe(onNext: {_ in
            self.viewModel?.resetGraph()
        }).addDisposableTo(disposeBag)
        
        //Binding Logout Button
        btnLogout.rx.tap.subscribe(onNext:{_ in
            UserDefaults.standard.setValue("0", forKey: "share_user_remember")
            _ = self.navigationController?.popToRootViewController(animated: true)
        }).addDisposableTo(disposeBag)
        
        //Binding Back button
        btnBack.rx.tap.subscribe(onNext:{_ in
            _ = self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)

    }

}
