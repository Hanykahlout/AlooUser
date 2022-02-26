//
//  FavouriteApiController.swift
//  Aloo
//
//  Created by macbook on 10/26/21.
//

import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD

struct FavouriteApiController{
    
    
    public static var shard: FavouriteApiController = {
        let favouriteApiController = FavouriteApiController()
        return favouriteApiController
    }()
    
    
    func addFavourite(id:String,callback: @escaping (Bool,String,FavouriteVendorData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.addToFavourite.url, method: .post , parameters:["item_id":id],headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : BaseResponseObject<FavouriteVendorData> = Mapper<BaseResponseObject<FavouriteVendorData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }
    
    
    func deleteFavouriteItem(id:String,callback: @escaping Callback){
        SVProgressHUD.show()
        AF.request(API_KEYS.deleteFavourite.withId(id: id), method: .delete , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON {(response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                
                if let parsedMapperString : BaseResponseObject<FavouriteVendorData> = Mapper<BaseResponseObject<FavouriteVendorData>>().map(JSONString:str){
                    if parsedMapperString.status == true{
                        callback(true,parsedMapperString.message!)
                    }else{
                        callback(false,parsedMapperString.message!)
                    }
                }
            }
        }
    }
    
    
    func getFavourite(vendorTypeNumber:String,page:String,callback: @escaping (Bool,String,GetFavouriteByTypeData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getFavouriteByVendorType.with2Id(id1: vendorTypeNumber, id2: page), method: .get,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<GetFavouriteByTypeData> = Mapper<BaseResponseObject<GetFavouriteByTypeData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "",parsedMapperString.data)
                }
            }
        }
    }
    
    
    func getFavouriteItems(id:String,page:String,callback: @escaping (Bool,String,GetFavouriteItemsData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getFavouriteItems.with2Id(id1: id, id2: page), method: .get,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<GetFavouriteItemsData> = Mapper<BaseResponseObject<GetFavouriteItemsData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "",parsedMapperString.data)
                }
            }
        }
    }
}
