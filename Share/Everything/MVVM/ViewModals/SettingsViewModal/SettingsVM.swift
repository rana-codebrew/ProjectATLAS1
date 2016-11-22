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
    
    let disposeBag = DisposeBag()
    var provider: RxMoyaProvider<Share>!
    var userTracker: UserTrackerModal!
    var name = Variable<String?>("")
    var oldPassword = Variable<String?>("")
    var newPassword = Variable<String?>("")
    let SettingsVCObj:SettingsVC
    
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
                        default: print(userMap?.Umessage)
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
                        print(userMap?.Umessage)
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
                        print(userMap?.Umessage)
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
