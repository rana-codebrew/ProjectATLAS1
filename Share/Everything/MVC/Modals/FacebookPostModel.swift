//
//  FacebookPostModel.swift
//  Share
//
//  Created by Aseem 7 on 18/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
class FacebookPostModel: NSObject {

    var id : String!
    var created_time : String!
    var message : String?
    var story : String?
    
    init(arrResult: JSON)
    {
        super.init()
        id = arrResult["id"].stringValue 
        created_time = arrResult["created_time"].stringValue
        message = arrResult["message"].stringValue
        story = arrResult["story"].stringValue
    }
    
    override init() {
        super.init()
    }
    
    static func changeDictToModelArray (_ json1 : JSON) -> [FacebookPostModel] {
        var tempArr : [FacebookPostModel] = []
        for arrResult in json1.arrayValue[0] {
            let fbObj = FacebookPostModel(arrResult: arrResult.1)
            tempArr.append(fbObj)
        }
        return tempArr
    }
}
