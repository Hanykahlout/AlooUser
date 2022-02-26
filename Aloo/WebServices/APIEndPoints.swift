//
//  APIEndPoint.swift
//  Aloo
//
//  Created by macbook on 10/11/21.
//
import Foundation

enum API_KEYS: String {

    case BASE_URL = "https://aloo-app.com/api/v1/"
    //Customer
    case USER_REGISTER = "customer/auth/signup"
    case USER_LOGIN = "customer/auth/login"
    case USER_LOGUT = "customer/auth/logout"
    case verifyPhone = "customer/auth/verify/phone"
    case verifyEmail = "customer/auth/verify/email"
    case deletePlace = "customer/profile/places/delete/{id}"
    case resendPhone = "customer/auth/send_verify/phone"
    case forgetPassword = "customer/auth/password/forget"
    case resetPassword = "customer/auth/password/reset"
    
    case getUserData =  "customer/profile/show"
    case setUserData =  "customer/profile/edit"
    
    
    case addNewPlaces = "customer/profile/places/new"
    case getUserPlaces = "customer/profile/places"
    case deleteUserPlace = "customer/profile/places/delete/"
    
    
    case getUserWalletData = "customer/profile/wallet"
    case setFirebaseToken = "customer/profile/token"
    
    
    case getFavouriteByVendorType = "customer/favorite/{id1}?page={id2}"
    case getFavouriteItems = "customer/favorite/vendor/{id1}?page={id2}"
    case addToFavourite = "customer/favorite/add"
    case deleteFavourite = "customer/favorite/delete/{id}"
    
    //data
    case frequencyAskedQuestion = "data/faq/customer?page=2"
    case getAboutData = "data/about"
    case getCities = "data/cities"
    case getBanks = "data/banks"
    case getServiceProvider="data/services"
    case getCustomerPrivacy = "data/privacy/customer"
    case customerClientService="data/clientService/customer"
    case getAllCart = "customer/main/cart/list/{id}"
    case deletecartItem = "customer/main/cart/{id}/delete"
    case kitchenTypes = "data/kitchen"
    case restaurantTypes = "data/restaurant"
    case categories = "data/vendor/{id}/categories"
    case getItem = "customer/main/view/item/{id}"
    case showOrders = "customer/orders/list/{id}"
    case showOrder = "customer/orders/show/{id}"
    case addToCart = "customer/main/cart/add"
    case getCartItemData = "customer/main/cart/{id}/view"
    case editCartItem = "customer/main/cart/{id}/edit"
    case rateVendor = "customer/rate/branch/{id}"
    case submitCart = "customer/main/cart/toOrder/{id1}?place={id2}"
    case viewOffer = "customer/main/view/offer/{id}"
    case getNotification = "customer/profile/notification"
    case getPackages = "data/packages"
    case addPackage = "customer/packages/add/{id}"
    case cancelPackage = "customer/packages/cancel/{id}"
   

    
    var url: String {
        switch self {
        case .BASE_URL:
            return API_KEYS.BASE_URL.rawValue
            
        default:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue)"
        }
    }
    
    func withId(id: String) -> String {
        switch self {
        case .viewOffer,.deletePlace,.getAllCart,.deleteFavourite,.getItem,.showOrders,.showOrder,.rateVendor,.addPackage,.cancelPackage:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}", with: "\(id)"))"
        case .deletecartItem:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}/delete", with: "\(id)/delete"))"
        case .categories:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}/categories", with: "\(id)/categories"))"
        case .getCartItemData:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}/view", with: "\(id)/view"))"
        case .editCartItem:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id}/edit", with: "\(id)/edit"))"
        default:
            return ""
        }
    }
    
    func with2Id(id1: String,id2: String) -> String {
        switch self {
        case .getFavouriteByVendorType,.getFavouriteItems:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id1}?page={id2}", with: "\(id1)?page=\(id2)"))"
        case .submitCart:
            return "\(API_KEYS.BASE_URL.rawValue)\(self.rawValue.replacingOccurrences(of: "{id1}?place={id2}", with: "\(id1)?place=\(id2)"))"
        default:
            return ""
        }
    }
    
}
