//
//  CustomersServiceViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 19/10/2021.
//

import UIKit

class CustomersServiceViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var serviceTableHeightConstrant: NSLayoutConstraint!
    
    
    private var allCells = [(image:UIImage,title:String,badge:Int,isLang:Bool,lang:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization(){
        setUpTableView()
        setCellsData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    private func setCellsData(){
        
        
        allCells.append((#imageLiteral(resourceName: "q-icon"),NSLocalizedString("Questions", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "clint-server-icon"),NSLocalizedString("Technical support", comment: ""),0,false,""))
        allCells.append((#imageLiteral(resourceName: "clint-server-icon"),NSLocalizedString("Complaint", comment: ""),0,false,""))
        
        serviceTableHeightConstrant.constant = CGFloat(allCells.count * 70)
    }
    

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension CustomersServiceViewController:UITableViewDelegate,UITableViewDataSource{
    func setUpTableView(){
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        serviceTableView.register(.init(nibName: "MyAccountPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAccountPageTableViewCell")
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
        let vc = QuestionViewController()
        switch indexPath.row {
        case 0:
            vc.type = "question"
            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            vc.type = "complaint"
            navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            vc.type = "support"
            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    
    
}
