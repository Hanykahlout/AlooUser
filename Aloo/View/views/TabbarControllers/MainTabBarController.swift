//
//  MainTabBarController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 22/09/2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    private func initlization(){
        tabBar.unselectedItemTintColor = .white
        tabBar.items![0].imageInsets = UIEdgeInsets(top: -23, left: 0, bottom: 0, right: 0)
        tabBar.layer.cornerRadius = 25
        tabBar.layer.masksToBounds = false
        tabBar.clipsToBounds = false
        tabBar.shadow_Radius = 6
        tabBar.shadow_Offset = CGSize(width: 0, height: 3)
        tabBar.shadow_Opacity = 1
        tabBar.shadow_Color = .black
    }
    
}


extension MainTabBarController{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for i in tabBar.items! {
            if i == item{
                i.imageInsets = UIEdgeInsets(top: -23, left: 0, bottom: 0, right: 0)
                continue
            }
            i.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

