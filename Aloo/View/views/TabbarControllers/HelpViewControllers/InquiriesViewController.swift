//
//  InquiriesViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 19/10/2021.
//

import UIKit

class InquiriesViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var inquiriesTableView: UITableView!
    
    private var demoData = [(isSuppotImageHidden:Bool,supportImage:UIImage,icon:UIImage,title:String,description:String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    private func initlization(){
        setUpTableView()
        setDameData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }

    private func setDameData(){
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((false,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
        demoData.append((true,#imageLiteral(resourceName: "clint-server-icon"),#imageLiteral(resourceName: "clint-server-icon"),"Reservation","sak alskd akds; sad;aoskdlm"))
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    
    
}


extension InquiriesViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableView(){
        inquiriesTableView.delegate = self
        inquiriesTableView.dataSource = self
        
        inquiriesTableView.register(.init(nibName: "InquiriesTableViewCell", bundle: nil), forCellReuseIdentifier: "InquiriesTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InquiriesTableViewCell", for: indexPath) as! InquiriesTableViewCell
        cell.setData(data: demoData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(InquiriesDetailsViewController(), animated: true)
    }
    
    
    
}
