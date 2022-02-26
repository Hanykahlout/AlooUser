//
//  PackagesViewControllerPresnter.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 04/12/2021.
//

import UIKit


protocol PackagesViewControllerPresnterDelegate{
    
}


typealias PackagesViewControllerDelegate = PackagesViewControllerPresnterDelegate & UIViewController

class PackagesViewControllerPresnter:NSObject{
    
    weak var delegate:PackagesViewControllerDelegate?
    
    
}
