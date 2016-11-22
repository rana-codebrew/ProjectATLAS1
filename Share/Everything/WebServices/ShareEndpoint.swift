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
      
      enum parameters:String
        {
            case name = "name"
            case email = "email"
            case password = "password"
            case deviceToken = "deviceToken"
            case deviceType = "deviceType"
            case appVersion = "appVersion"
            case authorization = "authorization"
            case language = "language"
            case facebookTime = "facebookTime"
            case twitterTime = "twitterTime"
            case instagramTime = "instagramTime"
            case tumblrTime = "tumblrTime"
            case vineTime = "vineTime"
            case pinterestTime = "pinterestTime"
            var stringValue: String {
                return self.rawValue
            }
        }
        
        switch self {
        case .Login(let email, let passwd):
            let params: [String: Any] = [
                parameters.email.stringValue: email as Any,
                parameters.password.stringValue:passwd as Any,
                parameters.deviceType.stringValue:deviceTyp as Any,
                parameters.deviceToken.stringValue:deviceUUID as Any,
                parameters.appVersion.stringValue: appVersion as Any,
            ]
            return params
        case .ForgotPass(let email):
            let params: [String: Any] = [
                parameters.email.stringValue:email as Any
            ]
            return params
        case .GetStatus(),.Logout(),.ResetCounter():
            let params: [String: Any] = [
                parameters.authorization.stringValue:authkey as Any
            ]
            return params
        case .Register(let name,let email,let passwd):
            let params: [String:Any] = [
                parameters.name.stringValue:name as Any,
                parameters.email.stringValue:email as Any,
                parameters.password.stringValue:passwd as Any,
                parameters.deviceType.stringValue:deviceTyp as Any,
                parameters.deviceToken.stringValue:deviceUUID as Any,
                parameters.appVersion.stringValue: appVersion as Any,
                parameters.language.stringValue:"EN" as Any
            ]
            return params
        case .UpdatePassword(let password):
            let params: [String:Any] = [
                parameters.authorization.stringValue:authkey as Any,
                parameters.password.stringValue:password
            ]
            return params
        case .UpdateProfile(let name):
            let params : [String: Any] = [
                parameters.authorization.stringValue:authkey as Any,
                parameters.name.stringValue:name as Any,
                parameters.deviceToken.stringValue:deviceUUID as Any
            ]
            return params
        case .UpdateTime(let facebook,let instagram,let twitter,let tumblr,let vine,let pinterest):
            let params:[String: Any] = [
                parameters.authorization.stringValue:authkey as Any,
                parameters.facebookTime.stringValue:facebook as Any,
                parameters.instagramTime.stringValue:instagram as Any,
                parameters.twitterTime.stringValue:twitter as Any,
                parameters.tumblrTime.stringValue:tumblr as Any,
                parameters.vineTime.stringValue:vine as Any,
                parameters.pinterestTime.stringValue:pinterest as Any
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
    
    
  
//    var multipartBody: [MultipartFormData]? {
//      switch self {
//          case .Login(_, let profileImage, _):
//            guard let data = UIImageJPEGRepresentation(profileImage, 1.0) else { return nil }
//            return [MultipartFormData(provider: .Data(data), name: "files", mimeType:"image/jpeg", fileName: "photo.jpg")]
//          default:
//            return nil
//      }
//  }
}
