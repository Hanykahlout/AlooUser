//
//  HelpViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 22/09/2021.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var helpTableView: UITableView!
    
    private var allCells = [(image:UIImage,title:String,badge:Int,isLang:Bool,lang:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization(){
        setUpTableView()
        setCellsData()
    }
    
    private func setCellsData(){
        allCells.append((#imageLiteral(resourceName: "clint-server-icon"),NSLocalizedString("Customers Service", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "q-icon"),NSLocalizedString("Common Questions", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "about-icon"),NSLocalizedString("About The App", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "privacy-icon"),NSLocalizedString("Terms And Conditions And Privacy Policy", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "rating-icon"),NSLocalizedString("App Rating", comment: ""),0,false,""))
    }
    
    
}


extension HelpViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        helpTableView.delegate = self
        helpTableView.dataSource = self
        
        helpTableView.register(.init(nibName: "MyAccountPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAccountPageTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountPageTableViewCell", for: indexPath) as! MyAccountPageTableViewCell
        cell.setData(data: allCells[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "CustomersServiceViewController") as! CustomersServiceViewController
            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            navigationController?.pushViewController(FAQViewController(), animated: true)
            break
        case 2:
            navigationController?.pushViewController(AboutAppViewController(), animated: true)
            break
        case 3:
            navigationController?.pushViewController(RulesConditionsViewController(), animated: true)
            break
        case 4:
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1590322735") else {
                return
            }
            if UIApplication.shared.canOpenURL(url){
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            break
        default:
            break
        }
    }
    
}


