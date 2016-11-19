//
//  UserTrackerModal.swift
//  Share
//
//  Created by Aseem 14 on 17/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct UserTrackerModal {
    let provider: RxMoyaProvider<Share>
    func validateLogin(email:String , passwd:String) -> Observable<UserMap?>  {
        
        return self.provider
            .request(Share.Login(email: email, password: passwd))
            .debug()
            .mapObjectOptional(type:UserMap.self)
    }
    
    func registerUser(name:String, email:String, passwd:String) -> Observable<UserMap?> {
        return self.provider
            .request(Share.Register(name: name, email: email, password: passwd))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    func forgotPass(email:String) -> Observable<UserMap?> {
        return self.provider
            .request(Share.ForgotPass(email: email))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    func updateProfile(name:String) -> Observable<UserMap?> {
        return self.provider
            .request(Share.UpdateProfile(name: name))
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
    
    func resetCounter() -> Observable<UserMap?> {
        return self.provider
            .request(Share.ResetCounter())
            .debug()
            .mapObjectOptional(type: UserMap.self)
    }
}
