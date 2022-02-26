



import Foundation
import ObjectMapper

struct CitiesBaseResponse : Mappable {
    var message : String?
    var data : CitiesBasedData?
    var errors : Errors?
    var content_language : String?
    var status : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        data <- map["data"]
        errors <- map["errors"]
        content_language <- map["content-language"]
        status <- map["status"]
    }

}
