//
//  HomeApiController.swift
//  Aloo
//
//  Created by macbook on 10/25/21.
//

import Foundation
import ObjectMapper
import Alamofire
import SVProgressHUD
struct HomeApiController{
    
    public static var shard: HomeApiController = {
        let homeApiController = HomeApiController()
        return homeApiController
    }()
    
    
    
    
    func listGuestVendor(vendor_id:String,page:String,lon:String,lat:String,orderId:String,kitchenType:String,restaurantType:String,callback: @escaping (Bool,String,ListVendorData?) -> Void){
        let url = "https://aloo-app.com/api/v1/customer/main/list/\(vendor_id)?page=\(page)&lon=\(lon)&lat=\(lat)&order_by=\(orderId)&kitchen_type=\(kitchenType)&restaurant_type=\(restaurantType)"
        SVProgressHUD.show()
        AF.request(url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<ListVendorData> = Mapper<BaseResponseObject<ListVendorData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }
    
    
    func listUserVendor(vendor_id:String,page:String,placeId:String,orderId:String,kitchenType:String,restaurantType:String,callback: @escaping (Bool,String,ListVendorData?) -> Void){
        let url = "https://aloo-app.com/api/v1/customer/main/list/\(vendor_id)?page=\(page)&place_id=\(placeId)&order_by=\(orderId)&kitchen_type=\(kitchenType)&restaurant_type=\(restaurantType)"
        SVProgressHUD.show()
        AF.request(url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<ListVendorData> = Mapper<BaseResponseObject<ListVendorData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false,parsedMapperString.message ?? "" , parsedMapperString.data)
                }
            }
        }
    }
    
    
    
    func getCategories(id:String,callback:@escaping(Bool,CategoriesData?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.categories.withId(id: id), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<CategoriesData> = Mapper<BaseResponseObject<CategoriesData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.data)
                }
            }
        }
    }
    
    
    
    func listVendorItem(page:String,order_by:String,category:String,vendor_id:String,callback: @escaping (Bool,RestaurantItemsData?,String) -> Void){
        let url =  "https://aloo-app.com/api/v1/customer/main/list/items/\(vendor_id)?page=\(page)&order_by=\(order_by)&category=\(category)"
        print("url \(url)")
        SVProgressHUD.show()
        AF.request(url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<RestaurantItemsData> = Mapper<BaseResponseObject<RestaurantItemsData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.data ,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    func listVendorSupermarketItem(page:String,order_by:String,category:String,vendor_id:String,callback: @escaping (Bool,GetFavouriteItemsData?,String) -> Void){
        let url =  "https://aloo-app.com/api/v1/customer/main/list/items/\(vendor_id)?page=\(page)&order_by=\(order_by)&category=\(category)"
        
        SVProgressHUD.show()
        AF.request(url, method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<GetFavouriteItemsData> = Mapper<BaseResponseObject<GetFavouriteItemsData>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.data ,parsedMapperString.message ?? "")
                }
            }
        }
    }
    
    
    
    func getItem(itemId:String,callback:@escaping(Bool,String,FavouriteItems?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getItem.withId(id: itemId), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<FavouriteItems> = Mapper<BaseResponseObject<FavouriteItems>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "", parsedMapperString.data )
                }
            }
        }
    }
    
    
    func getSuperMarketItem(id:String,callback:@escaping(Bool,String,SuperMarketVendorItem?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.getItem.withId(id: id), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<SuperMarketVendorItem> = Mapper<BaseResponseObject<SuperMarketVendorItem>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "", parsedMapperString.data )
                }
            }
        }
    }
    
    
    
    func getOffer(offerId:String,callback:@escaping(Bool,String,FavouriteItems?)->Void){
        SVProgressHUD.show()
        AF.request(API_KEYS.viewOffer.withId(id: offerId), method: .get , parameters:nil,headers:["Accept-Language": UserDefaults.standard.string(forKey: "AppLang") ?? "en","Authorization":"\(UserDefaults.standard.value(forKey: "Token") ?? "")","Accept":"application/json"]).validate().responseJSON { (response) in
            SVProgressHUD.dismiss()
            if let data  = response.data,let str : String = String(data: data, encoding: .utf8){
                if let parsedMapperString : BaseResponseObject<FavouriteItems> = Mapper<BaseResponseObject<FavouriteItems>>().map(JSONString:str){
                    callback(parsedMapperString.status ?? false, parsedMapperString.message ?? "", parsedMapperString.data )
                }
            }
        }
    }
    
}
