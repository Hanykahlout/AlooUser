//
//  FAQViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 29/09/2021.
//

import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var FAQTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    private var demoData:[Items]=[]
    private var selectedIndex = -1
    private let presnter = QuePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization(){
        presnter.delegate=self
        setUpTableView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.FrequentlyQuestion()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension FAQViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        FAQTableView.delegate = self
        FAQTableView.dataSource = self
        FAQTableView.rowHeight = 60
        FAQTableView.register(.init(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell", for: indexPath) as! FAQTableViewCell
        cell.setData(data: demoData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FAQTableViewCell
        cell.answerLabel.isHidden = !cell.answerLabel.isHidden
        
        selectedIndex = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex != -1{
            let cell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell
            if indexPath.row == selectedIndex {
                
                cell?.showHideButton.transform = .init(rotationAngle: .pi)
                return UITableView.automaticDimension
            }
            cell?.showHideButton.transform = .init(rotationAngle: 0)
            return 80
        }
        return 80
    }
}


extension FAQViewController:QuePresenterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)

    }
    
    func QuestionItem(data: [Items]) {
        demoData=data
        FAQTableView.reloadData()
    }
    
    
    
    
    
    
    
}
