//
//  AuthApiControllers.swift
//  Aloo
//
//  Created by macbook on 10/11/21.
//
import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD


typealias Callback = ( _ status: Bool ,_ message:String) -> Void
typealias CallbackCheck = ( _ status: Bool) -> Void


struct AuthApiControllers{
    
    public static var shard: AuthApiControllers = {
        let authApiControllers = AuthApiControllers()
        return authApiControllers
    }()
    
    
    func logout( callback: @escaping Callback){
        SVProgressHUD.show()
        AF.request(API_KEYS.USER_LOGUT.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : Logout = Mapper<Logout>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false, parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    
    func Login(phone: String,password:String, callback: @escaping (LoginData?,Bool,String) ->Void){
        
        
        let parameters: Parameters = ["phone":phone,
                                      "password":password,
                                      "type": "ios"
        ]
        SVProgressHUD.show()
       
        AF.request(API_KEYS.USER_LOGIN.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : Login = Mapper<Login>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(parsedMapperString.data!, true, parsedMapperString.message!)
                    }else{
                        callback( nil , false, parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    func verifyPhone(phone: String,verify_code:String, callback:  @escaping (_ data:VerifyPhoneData?,_ status:Bool,_ message:String) -> Void) {
        
        let parameters: Parameters = ["phone":phone,
                                      "verify_code":verify_code]
        
        SVProgressHUD.show()
        AF.request(API_KEYS.verifyPhone.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : VerifyPhoneResponse = Mapper<VerifyPhoneResponse>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(parsedMapperString.data,parsedMapperString.status!, parsedMapperString.message!)
                    }else{
                        callback(parsedMapperString.data,parsedMapperString.status!, parsedMapperString.message!)
                    }
                }
            }
        }
    }
    
    
    func verifyEmail(email: String,verify_code:String, callback:  @escaping Callback) -> Void{

        let parameters: Parameters = ["email":email,
                                      "verify_code":verify_code]
        
        SVProgressHUD.show()
        AF.request(API_KEYS.verifyEmail.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : VerifyPhoneResponse = Mapper<VerifyPhoneResponse>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(parsedMapperString.status!, parsedMapperString.message!)
                    }else{
                        callback(parsedMapperString.status!,  parsedMapperString.message!)
                        
                    }
                }
            }
        }
    }
    
    
    func signUp(user:User, callback:  @escaping Callback) -> Void{
        
        let parameters: Parameters = ["name":user.name,
                                      "phone":user.mobile,
                                      "gender":user.gender,
                                      "password":user.password,
                                      "password_confirmation":user.confirmPassword,
                                      "city":user.city
        ]
        SVProgressHUD.show()
        AF.request(API_KEYS.USER_REGISTER.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : SignUpResponse = Mapper<SignUpResponse>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        
                        callback(parsedMapperString.status!, parsedMapperString.message!)
                    }else{
                        callback(parsedMapperString.status!, parsedMapperString.message!)
                    }                    
                }
            }
        }
    }
    
    func resendCode(phone:String,callback:  @escaping Callback) -> Void{
        
        let parameters: Parameters = ["phone":phone]
        SVProgressHUD.show()
        AF.request(API_KEYS.resendPhone.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SignUpResponse> = Mapper<BaseResponseObject<SignUpResponse>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
 
    
    func forgetPassword(phone:String,callback:  @escaping Callback) -> Void{
        let parameters: Parameters = ["phone":phone]
        SVProgressHUD.show()
        AF.request(API_KEYS.forgetPassword.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SignUpResponse> = Mapper<BaseResponseObject<SignUpResponse>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    func resetPassword(phone:String,code:String,password:String,callback:  @escaping Callback) -> Void{
        let parameters: Parameters = ["phone":phone,"code":code,"password":password]
        SVProgressHUD.show()
        AF.request(API_KEYS.resetPassword.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SignUpResponse> = Mapper<BaseResponseObject<SignUpResponse>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
}



