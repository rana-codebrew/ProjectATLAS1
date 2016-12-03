//
//  UserMapper.swift
//  Share
//
//  Created by Aseem 14 on 17/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Mapper

struct UserMap: Mappable{
    var Umessage: String?
    var UstatusCode: Int?
    var UserData : UserData?
     init(map: Mapper) throws{
        UstatusCode = try? map.from("statusCode")
        Umessage = try? map.from("message")
        UserData = (try? map.from("data")) ?? nil
    }
}

struct UserData: Mappable{
    var userDetails: Userdetails?
    var UaccessToken: String?
    var name: String?
    
    var facebookTime:Int!
    var instagramTime:Int!
    var tumblrTime:Int!
    var twitterTime:Int!
    var pinterestTime:Int!
    var vineTime:Int!
    
    init(map: Mapper) throws{
        UaccessToken = try? map.from("accessToken")
        userDetails = (try? map.from("userDetails")) ?? nil
        name = (try? map.from("name")) ?? ""
        facebookTime = (try? map.from("facebookTime")) ?? 0
        instagramTime = (try? map.from("instagramTime")) ?? 0
        tumblrTime = (try? map.from("tumblrTime")) ?? 0
        twitterTime = (try? map.from("twitterTime")) ?? 0
        pinterestTime = (try? map.from("pinterestTime")) ?? 0
        vineTime = (try? map.from("vineTime")) ?? 0
    }
}

struct Userdetails: Mappable{
    var name: String?
    init(map: Mapper) throws{
        name = try? map.from("name")
    }
}
