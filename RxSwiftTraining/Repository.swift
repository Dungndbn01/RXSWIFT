//
//  Repository.swift
//  RxSwiftTraining
//
//  Created by Nguyen Dinh Dung on 2018/02/12.
//  Copyright © 2018年 Nguyen Dinh Dung. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
