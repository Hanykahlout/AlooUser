//
//  FavoriteViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noSelectionView: UIView!
    @IBOutlet weak var noSelectionImageView: UIImageView!
    @IBOutlet weak var noSelectionLabel: UILabel!
    
    @IBOutlet weak var selectionTypeView: UIView!
    @IBOutlet weak var selectionTypeLabel: UILabel!
    @IBOutlet weak var selectionNameView: UIView!
    @IBOutlet weak var selectionNameLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var selectionTableView: UITableView!
    @IBOutlet weak var selectionView: UIView!
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var selectTypeView: UIView!
    @IBOutlet weak var resturentsView: UIView!
    @IBOutlet weak var superMarketView: UIView!
    @IBOutlet weak var pharmaciesView: UIView!
    
    let presnter = FavoritePresnter()
    private var productsData = [FavouriteItems]()
    private var selectionData = [Vendors]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        presnter.delegate = self
        setUpTableView()
        setUpCollectionView()
        setUpViews()
        didSelectResturentsType()
        setLayers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    
    private func setUpViews(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectShadowView)))
        selectionTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickOnSelectType)))
        selectionNameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickOnSelectName)))
        resturentsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectResturentsType)))
        superMarketView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSuperMarketsType)))
        pharmaciesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectPharmaciesType)))
    }
    
    func setLayers(){
        let layer = UICollectionViewFlowLayout()
        layer.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layer.minimumInteritemSpacing = 10
        layer.minimumLineSpacing = 10
        layer.scrollDirection = .vertical
        layer.invalidateLayout()
        
        let size = ((self.view.frame.width / 2) - 30)
        
        layer.itemSize = CGSize(width: size, height: 187)
        productsCollectionView.setCollectionViewLayout(layer, animated: true)
    }
    
    
    @objc private func didClickOnSelectType(){
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.shadowView.isHidden = false
            self.selectTypeView.isHidden = false
        })
    }
    
    @objc private func didClickOnSelectName(){
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.shadowView.isHidden = false
            self.selectionView.isHidden = false
        })
    }
    
    
    @objc private func didSelectResturentsType(){
        presnter.getFavoriteVendors(type: "3", page: "1")
        selectionTypeLabel.text = NSLocalizedString("Restaurants", comment: "")
        selectionNameLabel.text = NSLocalizedString("Select Restaurants", comment: "")
        favoritesTableView.isHidden = true
        productsCollectionView.isHidden = true
        noSelectionImageView.image = #imageLiteral(resourceName: "unselected-res-icon")
        noSelectionLabel.text = NSLocalizedString("Please choose a restaurant", comment: "")
        noSelectionView.isHidden = false
        didSelectShadowView()
    }
    
    @objc private func didSelectSuperMarketsType(){
        presnter.getFavoriteVendors(type: "1", page: "1")
        selectionTypeLabel.text = NSLocalizedString("SuperMarkets", comment: "")
        selectionNameLabel.text = NSLocalizedString("Select SuperMarkets", comment: "")
        favoritesTableView.isHidden = true
        productsCollectionView.isHidden = true
        noSelectionImageView.image = #imageLiteral(resourceName: "cart-icon")
        noSelectionView.isHidden = false
        didSelectShadowView()
    }
    
    @objc private func didSelectPharmaciesType(){
        presnter.getFavoriteVendors(type: "2", page: "1")
        selectionTypeLabel.text = NSLocalizedString("Pharmacies", comment: "")
        selectionNameLabel.text = NSLocalizedString("Select Pharmacies", comment: "")
        favoritesTableView.isHidden = true
        productsCollectionView.isHidden = true
        noSelectionImageView.image = #imageLiteral(resourceName: "unselected-ph-icon")
        noSelectionLabel.text = NSLocalizedString("Please choose a pharmacie", comment: "")
        noSelectionView.isHidden = false
        didSelectShadowView()
    }
    
    
    @objc private func didSelectShadowView(){
        shadowView.isHidden = true
        selectTypeView.isHidden = true
        selectionView.isHidden = true
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension FavoriteViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableView(){
        selectionTableView.delegate = self
        selectionTableView.dataSource = self
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        selectionTableView.register(.init(nibName: "FavoriteSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteSelectionTableViewCell")
        favoritesTableView.register(.init(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favoritesTableView{
            return productsData.count
        }else{
            return selectionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == favoritesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
            cell.setData(data: productsData[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSelectionTableViewCell", for: indexPath) as! FavoriteSelectionTableViewCell
            cell.selectionTitleLabel.text = selectionData[indexPath.row].name ?? ""
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == favoritesTableView{
            
        }else{
            presnter.getFavoriteItems(id: String(selectionData[indexPath.row].id ?? -1), page: "1")
            productsCollectionView.isHidden = selectionTypeLabel.text == NSLocalizedString("Restaurants", comment: "")
            favoritesTableView.isHidden = selectionTypeLabel.text != NSLocalizedString("Restaurants", comment: "")
            noSelectionView.isHidden = true
            didSelectShadowView()
        }
    }
    
}


extension FavoriteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollectionView(){
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        productsCollectionView.register(.init(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.setData(data: productsData[indexPath.row])
        return cell
    }
    
}


extension FavoriteViewController:FavoritePresnterDelegate{
    func setItems(data: GetFavouriteItemsData) {
        productsData = data.items ?? []
        if selectionTypeLabel.text == NSLocalizedString("Restaurants", comment: ""){
            favoritesTableView.reloadData()
        }else{
            productsCollectionView.reloadData()
        }
        
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func setVendorsList(data: GetFavouriteByTypeData) {
        selectionData = data.vendors ?? []
        selectionTableView.reloadData()
    }

    
}
