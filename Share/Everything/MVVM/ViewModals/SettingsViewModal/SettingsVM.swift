//
//  SettingsVM.swift
//  Share
//
//  Created by Aseem 14 on 21/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class SettingsVM{

//MARK: - local Variables
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    var name = Variable<String?>("")
    var oldPassword = Variable<String?>("")
    var newPassword = Variable<String?>("")
    let SettingsVCObj:SettingsVC
    
//MARK: - Initializing ViewModel
    init(settingsVCObj:SettingsVC){
        
        let endpointClosure = { (target: Share) -> Endpoint<Share> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(target)
            let authkey = "bearer " + (UserDefaults.standard.value(forKey: "share_auth_token") as! String)
            return defaultEndpoint.adding(newHttpHeaderFields: ["authorization": authkey])
        }
        let providerWithHeader = RxMoyaProvider<Share>(endpointClosure: endpointClosure)
        
        self.provider = RxMoyaProvider<Share>()
        self.userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:providerWithHeader)
        SettingsVCObj=settingsVCObj
    }
    
//MARK: - Saving New Name
    func saveName() {
        self.userTracker.updateProfile(name: name.value!)
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    guard let statusCode = userMap?.UstatusCode else{
                        return
                    }
                    switch(statusCode){
                        case 200:self.SettingsVCObj.presentError(title:"Success",message:(userMap?.Umessage)!,okText:"OK")
                        default: print(userMap?.Umessage ?? "Success")
                    self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                        
                    }
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)
    }
    
//MARK: - Change Password
    func chnagePassword() {
        self.userTracker.changePassword(oldPass: oldPassword.value!, newPass: newPassword.value!)
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    
                    if(userMap?.UstatusCode == 200)
                    {
                        self.SettingsVCObj.presentError(title:"Success",message:(userMap?.Umessage)!,okText:"OK")
                    }
                    else
                    {
                        print(userMap?.Umessage ?? "Success")
                        self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)
    }

//MARK: - Reset Graph
    func resetGraph() {
        self.userTracker.resetCounter()
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    
                    if(userMap?.UstatusCode == 200)
                    {
                        self.SettingsVCObj.presentError(title:"Success",message:(userMap?.Umessage)!,okText:"OK")
                    }
                    else
                    {
                        print(userMap?.Umessage ?? "Error Occured")
                        self.SettingsVCObj.presentError(title:"Attention",message:(userMap?.Umessage)!,okText:"OK")
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.SettingsVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)
    }
}
