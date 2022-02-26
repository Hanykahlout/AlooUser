//
//  DataApiControllers.swift
//  Aloo
//
//  Created by macbook on 10/11/21.
//

import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD
struct DataApiControllers{
    
    public static var shard: DataApiControllers = {
        let dataApiControllers = DataApiControllers()
        return dataApiControllers
    }()
    
    
    func GetCities(callback: @escaping (CitiesBasedData?,Bool,String) ->Void){
        
        let parameters: Parameters? = nil
        SVProgressHUD.show()
        AF.request(API_KEYS.getCities.url, method: .get , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : CitiesBaseResponse = Mapper<CitiesBaseResponse>().map(JSONString:str){
                    callback(parsedMapperString.data,parsedMapperString.status ?? false , parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func getServiceProvider(callback: @escaping (Bool,[Supported_vendors]?,String) -> Void){
        AF.request(API_KEYS.getServiceProvider.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : BaseResponseObject<ServiceProvideData> = Mapper<BaseResponseObject<ServiceProvideData>>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.data?.supported_vendors,parsedMapperString.message ?? "Data get Sucessfully")
                    }else{
                        callback(false,parsedMapperString.data?.supported_vendors,parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    
    
    
    func GetAbout(callback: @escaping (Bool,AboutData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getAboutData.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : About = Mapper<About>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true,parsedMapperString.data)
                    }else{
                        callback(false,nil)
                    }
                }
            }
        }
    }
    
    func privacyPolicy(callback: @escaping (Bool,PrivacyPolicyData?) ->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getCustomerPrivacy.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : PrivacyPolicy = Mapper<PrivacyPolicy>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.data)
                    }else{
                        callback(false, nil)
                    }
                }
            }
        }
    }
    
    func customerClientService(type:String,question:String,callback: @escaping Callback){
        
        let parameters: Parameters = ["type":type, "question":question]
        SVProgressHUD.show()
        AF.request(API_KEYS.customerClientService.url, method: .post , parameters:parameters,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : PrivacyPolicy = Mapper<PrivacyPolicy>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true, parsedMapperString.message!)
                    }else{
                        callback(false, parsedMapperString.message!)
                        
                    }
                    
                }
            }
        }
    }
    
    
    func frequentlyQue(callback: @escaping (Bool,[Items]?,String) ->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.frequencyAskedQuestion.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                
                if let parsedMapperString : FrequentlyQue = Mapper<FrequentlyQue>().map(JSONString:str){
                        callback(parsedMapperString.status ?? false, parsedMapperString.data?.items,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func getKitchenTypes(callback:@escaping (Bool,String,CitiesBasedData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.kitchenTypes.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<CitiesBasedData> = Mapper<BaseResponseObject<CitiesBasedData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }
    
    func getRestaurantTypes(callback:@escaping (Bool,String,CitiesBasedData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.restaurantTypes.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<CitiesBasedData> = Mapper<BaseResponseObject<CitiesBasedData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }
    
    
    func getPackages(callback:@escaping (Bool,String,PackageData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getPackages.url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<PackageData> = Mapper<BaseResponseObject<PackageData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }

    
    
    
}







