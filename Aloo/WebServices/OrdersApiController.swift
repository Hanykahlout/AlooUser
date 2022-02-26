//
//  OrdersApiController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 12/11/2021.
//

import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper

class OrdersApiController:NSObject{
    
    public static var shard: OrdersApiController = {
        let ordersApiController = OrdersApiController()
        return ordersApiController
    }()
    
    
    func getServiceProvider(id:String,callback: @escaping (Bool,ShowOrdersData?,String) -> Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.showOrders.withId(id: id), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<ShowOrdersData> = Mapper<BaseResponseObject<ShowOrdersData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.data,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func showOrder(id:String,callback: @escaping (OrderData?) -> Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.showOrder.withId(id: id), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<OrderData> = Mapper<BaseResponseObject<OrderData>>().map(JSONString:str){
                    callback(parsedMapperString.data)
                }
            }
        }
    }
    
    
    func rateVendor(id:String,rate:Double,message:String,callback:@escaping (Bool,String)->Void){
        SVProgressHUD.show()
        
        AF.request(API_KEYS.rateVendor.withId(id: id), method: .post , parameters:["rate":rate,"message":message],headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<OrderData> = Mapper<BaseResponseObject<OrderData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    func addPackage(id:String,callback:@escaping (Bool,String,String,String)->Void){
        
        SVProgressHUD.show()
        AF.request(API_KEYS.addPackage.withId(id: id), method: .get ,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<Links> = Mapper<BaseResponseObject<Links>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "",parsedMapperString.data?.url ?? "" ,parsedMapperString.data?.stc ?? "")
                }
            }
        }
    }
    
    func cancelPackage(id:String,callback:@escaping (Bool,String)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.cancelPackage.withId(id: id), method: .get ,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<Links> = Mapper<BaseResponseObject<Links>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
}
