//
//  ResturentPageCellPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 01/12/2021.
//

import UIKit

protocol ResturentPageCellPresnterDelegate{
    func changeFavoriteButtonStatus(isSelected:Bool)
}

typealias ResturentPageCellDelegate = ResturentPageCellPresnterDelegate & UITableViewCell

class ResturentPageCellPresnter:NSObject{
    
    weak var delegate:ResturentPageCellDelegate?
    
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
