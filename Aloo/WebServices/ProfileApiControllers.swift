//
//  ProfileApiControllers.swift
//  Aloo
//
//  Created by macbook on 10/11/21.
//

import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD
struct ProfileApiControllers{
    
    public static var shard: ProfileApiControllers = {
        let profileApiControllers = ProfileApiControllers()
        return profileApiControllers
    }()
    
    
    func getUserData( callback: @escaping (Bool,String,UserDataResponseData?) ->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getUserData.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UserDataResponse = Mapper<UserDataResponse>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" ,parsedMapperString.data)
                }
            }
        }
    }
    
    
    func setUserData(user:UserData, callback:  @escaping Callback) -> Void{
        
        let parameters: Parameters = ["name":user.name,
                                      "phone":user.mobile,
                                      "address":user.gender,
                                      "password":user.password,
                                      "password_confirmation":user.confirmPassword,
                                      "city":user.city,
                                      "email":user.email
        ]
        SVProgressHUD.show()
        let imgData = user.img?.jpegData(compressionQuality: 0.2)!
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imgData = imgData {
                multipartFormData.append(imgData, withName: "fileset", mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)                }
            
        },
                  to:API_KEYS.setUserData.url, method: .post,headers: ["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : UserDataaResponse = Mapper<UserDataaResponse>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false, parsedMapperString.message!)
                    }
                }
            }
        }
    }
    
    
    func firebaseToken(token:String ,callback: @escaping Callback){
        SVProgressHUD.show()
        let parameters: Parameters = ["token":token]
        AF.request(API_KEYS.setFirebaseToken.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : FirebaseToken = Mapper<FirebaseToken>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false, parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    
    func wallet(callback:@escaping (Bool,String,UserWalletData?) -> Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getUserWalletData.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : BaseResponseObject<UserWalletData> = Mapper<BaseResponseObject<UserWalletData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "",parsedMapperString.data)
                }
            }
        }
    }
    
    
    func getNotification(callback:@escaping (Bool,String,GetNotificationInfo?) -> Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getNotification.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : BaseResponseObject<GetNotificationInfo> = Mapper<BaseResponseObject<GetNotificationInfo>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "",parsedMapperString.data)
                }
            }
        }
    }
    
}



