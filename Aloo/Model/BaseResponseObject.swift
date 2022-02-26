//
//  BaseResponseObject.swift
//  AlooDriver
//
//  Created by Hany Alkahlout on 24/10/2021.
//

import Foundation
import ObjectMapper


struct BaseResponseObject<T: Mappable>:Mappable{

    var message : String?
    var data : T?
    var status : Bool?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        
    }
    
}


