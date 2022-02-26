//
//  CartApiController.swift
//  Aloo
//
//  Created by macbook on 10/26/21.
//

import Foundation
import Alamofire
import ObjectMapper
import SVProgressHUD

struct CartApiController{
    
    public static var shard: CartApiController = {
        let cartApiController = CartApiController()
        return cartApiController
    }()
    
    
    func GetAllCart(id:String,callback: @escaping (Bool,CartDataReponse?,String) -> Void){
        
        SVProgressHUD.show()
        AF.request(API_KEYS.getAllCart.withId(id: id), method: .get,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<CartDataReponse> = Mapper<BaseResponseObject<CartDataReponse>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.data,parsedMapperString.message ?? "")
                }
            }
        }
        
    }
    
    
    
    func addToCartInSupermarket(itemId:String,amount:String,callback:@escaping(Bool,String)->Void){
        SVProgressHUD.show()
        let param = ["item_id":itemId,"amount":amount]
        AF.request(API_KEYS.addToCart.url, method: .post , parameters:param,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func addToCartInResturants(itemId:String,amount:String,with:[String],without:[String],size:String,drinks:[Int],extras:[Int],callback:@escaping(Bool,String)->Void){
        SVProgressHUD.show()
        let param:[String:Any] = ["item_id":itemId,"amount":amount,"with":with,"without":without,"size":size,"drinks":drinks,"extras":extras]
        AF.request(API_KEYS.addToCart.url, method: .post , parameters:param,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func addToCartInOffer(offerId:String,amount:String,callback:@escaping(Bool,String)->Void){
        SVProgressHUD.show()
        let param = ["offer_id":offerId,"amount":amount]
        AF.request(API_KEYS.addToCart.url, method: .post , parameters:param,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func getCartItemData(id:String,callback:@escaping (Bool,String,CartItems?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getCartItemData.withId(id: id), method: .get ,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<CartItems> = Mapper<BaseResponseObject<CartItems>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "",parsedMapperString.data)
                }
            }
        }
    }
    
    
    
    
    func deleteFromCart(id:String,callback:@escaping (Bool,String)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.deletecartItem.withId(id: id), method: .delete ,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func editRestaurantCartItem(amount:String,with:[String],without:[String],size:String,drinks:[Int],extras:[Int],id:String,callback:@escaping (Bool,String)->Void){
        SVProgressHUD.show()
        let param:Parameters = ["amount":amount,"with":with,"without":without,"size":size,"drinks":drinks,"extras":extras]
        AF.request(API_KEYS.editCartItem.withId(id: id), method: .post ,parameters: param,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    func editSuperMarketCartItem(amount:String,id:String,callback:@escaping (Bool,String)->Void){
        SVProgressHUD.show()
        let param:Parameters = ["amount":amount]
        AF.request(API_KEYS.editCartItem.withId(id: id), method: .post ,parameters: param,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    func submitCart(supportedVendorId:String,placeId:String,callback:@escaping (Bool,String,String,String)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.submitCart.with2Id(id1: supportedVendorId, id2: placeId), method: .get ,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<Links> = Mapper<BaseResponseObject<Links>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "",parsedMapperString.data?.url ?? "",parsedMapperString.data?.stc ?? "")
                }
            }
        }
    }
    
    
    
    
}
