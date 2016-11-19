//
//  ShareEndpoint.swift
//  Share
//
//  Created by Aseem 14 on 17/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import Moya

enum Share {
    case Login(email: String, password: String)
    case Register(name: String, email: String, password: String)
    case ForgotPass(email: String)
    case GetStatus()
    case Logout()
    case ResetCounter()
    case UpdatePassword(password: String)
    case UpdateProfile(name: String)
    case UpdateTime(facebook:String, instagram:String, twitter:String, tumblr:String, vine:String, pinterest:String)
    
    
}

extension Share: TargetType {
    var baseURL: URL{return URL(string:"http://35.160.81.51:5001/api/users")!}
    var path: String {
        switch self {
        case .Login(_, _):
            return "/login"
        case .Register(_,_,_):
            return "/register"
        case .ForgotPass(_):
            return "/forgotPassword"
        case .GetStatus():
            return "/getStatus"
        case .Logout():
            return "/logout"
        case .ResetCounter():
            return "/resetCounter"
        case .UpdatePassword(_):
            return "updatePassword"
        case .UpdateProfile(_):
            return "updateProfile"
        case .UpdateTime(_, _, _, _, _, _):
            return "updateTime"
        }
    }
    var method: Moya.Method{
        switch self {
        case .Logout(),.ResetCounter(),.UpdateProfile(_),.UpdatePassword(_),.UpdateTime(_, _, _, _, _, _):
            return .put
        case .ForgotPass(_),.GetStatus(),.Login(_,_),.Register(_,_,_):
            return .post
        }
    }
    var parameters: [String: Any]?{

        let deviceTyp = "IOS"
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        var appVersion:String
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        else
        {
            appVersion = "1.0"
        }
        var authkey:String
        if  (UserDefaults.standard.value(forKey: "share_auth_token") != nil)
        {
            
            authkey = "bearer " + (UserDefaults.standard.value(forKey: "share_auth_token") as! String)
        }
        else
        {
            authkey = "na"
        }
        
        switch self {
        case .Login(let email, let passwd):
            let params: [String: Any] = [
                "email": email as Any,
                "password":passwd as Any,
                "deviceType":deviceTyp as Any,
                "deviceToken":deviceUUID as Any,
                "appVersion": appVersion as Any,
            ]
            return params
        case .ForgotPass(let email):
            let params: [String: Any] = [
                "email":email as Any
            ]
            return params
        case .GetStatus(),.Logout(),.ResetCounter():
            let params: [String: Any] = [
                "authorization":authkey as Any
            ]
            return params
        case .Register(let name,let email,let passwd):
            let params: [String:Any] = [
                "name":name as Any,
                "email":email as Any,
                "password":passwd as Any,
                "deviceType":deviceTyp as Any,
                "deviceToken":deviceUUID as Any,
                "appVersion": appVersion as Any,
                "language":"EN"
            ]
            return params
        case .UpdatePassword(let password):
            let params: [String:Any] = [
                "authorization":authkey as Any,
                "password":password
            ]
            return params
        case .UpdateProfile(let name):
            let params : [String: Any] = [
                "authorization":authkey as Any,
                "name":name as Any,
                "deviceToken":deviceUUID as Any
            ]
            return params
        case .UpdateTime(let facebook,let instagram,let twitter,let tumblr,let vine,let pinterest):
            let params:[String: Any] = [
                "authorization":authkey as Any,
                "facebookTime":facebook,
                "instagramTime":instagram,
                "twitterTime":twitter,
                "tumblrTime":tumblr,
                "vineTime":vine,
                "pinterestTime":pinterest
            ]
            return params
        }
    }
    
    var sampleData: Data{
            return"{ \"statusCode\":400,\"message\":\"Success\",\"data\":{\"accessToken\":\"sample123456\"}}".data(using: String.Encoding.utf8)!
    }
    var task:Task{
        return .request
    }
}

