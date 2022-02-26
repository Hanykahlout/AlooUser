//
//  PlacesApiControllers.swift
//  Aloo
//
//  Created by macbook on 10/12/21.
//
import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD
struct PlacesApiControllers{
    
    public static var shard: PlacesApiControllers = {
        let placesApiControllers = PlacesApiControllers()
        return placesApiControllers
    }()
    
    
    func addNewPlaces(lon:String,lat:String,name:String,location_name:String, callback: @escaping Callback){
        
        let parameters: Parameters = ["lon":lon,"lat":lat,"name":name,"location_name":location_name]
        SVProgressHUD.show()
        AF.request(API_KEYS.addNewPlaces.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){                
                if let parsedMapperString : AddNewPlaces = Mapper<AddNewPlaces>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false,parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    
    func getNewPlaces(callback: @escaping (Bool,UserPlacesData?) -> Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getUserPlaces.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON {  (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : UserPlaces = Mapper<UserPlaces>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.data)
                    }else{
                        callback(false,parsedMapperString.data)
                    }
                }
            }
        }
    }
    
    
    func deletePlaces(id:String,callback: @escaping (Bool,String)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.deletePlace.withId(id: id), method: .delete , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : UserPlaces = Mapper<UserPlaces>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false,parsedMapperString.message!)
                    }
                    
                }
            }
        }
    }
    
    
}

