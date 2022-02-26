//
//  ProductsCellPresnter.swift
//  Aloo
//
//  Created by Hany Alkahlout on 13/11/2021.
//

import UIKit


protocol ProductsCellPresnterDelegate {
    func changeFavoriteButtonStatus(isSelected:Bool)
}


typealias ProductsCellDelegate = ProductsCellPresnterDelegate & UICollectionViewCell


class ProductsCellPresnter:NSObject{
    
    weak var delegate:ProductsCellDelegate?
    
    func addFavorite(id:String){
        
        FavouriteApiController.shard.addFavourite(id: id) { status, message, data in
            if status {
                DispatchQueue.main.async {
                    self.delegate?.changeFavoriteButtonStatus(isSelected: true)
                }
            }
        }
        
    }
    
    
    func deleteFavorite(id:String){
        
        FavouriteApiController.shard.deleteFavouriteItem(id: id) { status, message in
            if status {
                DispatchQueue.main.async {
                    self.delegate?.changeFavoriteButtonStatus(isSelected: false)
                }
            }
        }
        
    }
    
    
}
