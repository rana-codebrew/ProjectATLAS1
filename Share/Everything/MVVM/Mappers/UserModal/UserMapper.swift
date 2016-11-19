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
    init(map: Mapper) throws{
        UaccessToken = try? map.from("accessToken")
        userDetails = (try? map.from("userDetails")) ?? nil
        name = (try? map.from("name")) ?? ""
    }
}

struct Userdetails: Mappable{
    var name: String?
    init(map: Mapper) throws{
        name = try? map.from("name")
    }
}
