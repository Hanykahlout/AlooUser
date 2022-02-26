//
//  AlertsViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 27/09/2021.
//

import UIKit

class AlertsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var alertsTableView: UITableView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    
    private let presnter =  NotificationPresnter()
    
    private var notificationData = [NotificationItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presnter.getNotificationData()
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpTableView()
    }
    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension AlertsViewController:UITableViewDelegate,UITableViewDataSource {
    
    private func setUpTableView(){
        alertsTableView.delegate = self
        alertsTableView.dataSource = self
        alertsTableView.register(.init(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: "AlertTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        cell.setData(data: notificationData[indexPath.row])
        return cell
    }
    
}

extension AlertsViewController : NotificationPresnterDelegate{
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func notificationResponse(data: GetNotificationInfo) {
        notificationData = data.items ?? []
        alertsTableView.reloadData()
    }
    
    
    
}
