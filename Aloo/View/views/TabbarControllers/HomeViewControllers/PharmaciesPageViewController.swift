//
//  PharmaciesPageViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 07/10/2021.
//

import UIKit

class PharmaciesPageViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var byPriceView: UIViewCustomCornerRadius!
    @IBOutlet weak var pharmaciesPageTableView: UITableView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var pharmaciesImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var sectionView: UIViewCustomCornerRadius!
    @IBOutlet weak var lowestView: GraidentView!
    @IBOutlet weak var highestView: GraidentView!
    @IBOutlet weak var selectButton: UIButton!
    
    public var data:ListVendorItems?
    private var categories = [Categories]()
    private var items = [FavouriteItems]()
    private let presnter = ResturentPagePresnter()
    private var selectedSort = ""
    private var selectedCategoryId = ""
    private var counter = 1
//    private var isFromBottom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        navigationController?.navigationBar.isHidden = true
        backgroundImageView.image = UserDefaults.standard.bool(forKey: "isMarket") ? #imageLiteral(resourceName: "Group 4") : #imageLiteral(resourceName: "ph-bg-image")
        if let data = data{
            pharmaciesImageView.sd_setImage(with: URL(string: data.logo ?? ""))
            bgImageView.sd_setImage(with: URL(string: data.image ?? ""))
            presnter.getCategories(vendorId: String(data.id!))
            presnter.getListSupermarktsItems(page: String(counter), orderBy: "", category: "", vendorId: String(data.id!))
            
        }
        
    }
    
    
    private func initlization(){
        presnter.delegate = self
        pharmaciesImageView.image = #imageLiteral(resourceName: "logo img")
        bgImageView.image = #imageLiteral(resourceName: "demo-Image")
        setUpCollectionView()
        setUpTableView()
        setUpViews()
        setLayers()
    }
    
    
    func setLayers(){
        let layer = UICollectionViewFlowLayout()
        layer.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layer.minimumInteritemSpacing = 10
        layer.minimumLineSpacing = 10
        layer.scrollDirection = .vertical
        layer.invalidateLayout()
        
        let size = ((self.view.frame.width / 2) - 60)
        
        layer.itemSize = CGSize(width: size, height: 187)
        productsCollectionView.setCollectionViewLayout(layer, animated: true)
    }
    
    private func setUpViews(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowViewAction)))
        allView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allViewAction)))
        lowestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(highestAction)))
        highestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lowestAction)))
    }
    
    @objc private func shadowViewAction(){
        shadowView.isHidden = true
        sectionView.isHidden = true
        byPriceView.isHidden = true
    }
    
    
    @objc private func allViewAction(){
        self.shadowView.isHidden = false
        self.sectionView.isHidden = false
    }
    
    @objc private func highestAction(){
        selectedSort = "price_highest"
        selectButton.setTitle(NSLocalizedString("From Low To High", comment: ""), for: .normal)
        if let data = data{
            presnter.getListSupermarktsItems(page: String(counter), orderBy: selectedSort, category: selectedCategoryId, vendorId: String(data.id!))
        }
        shadowViewAction()
    }
    
    @objc private func lowestAction(){
        selectedSort = "price_lowest"
        selectButton.setTitle(NSLocalizedString("From High To Low", comment: ""), for: .normal)
        
        if let data = data{
            presnter.getListSupermarktsItems(page: String(counter), orderBy: selectedSort, category: selectedCategoryId, vendorId: String(data.id!))
        }
        shadowViewAction()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "Token") != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            vc.isRestaurant = false
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: LoginUserViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func selectAction(_ sender: Any) {
        self.shadowView.isHidden = false
        self.byPriceView.isHidden = false
    }
    
    
}


extension PharmaciesPageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollectionView(){
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        productsCollectionView.register(.init(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.setData(data: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailsViewController()
        if let id = items[indexPath.row].id{
            vc.id = String(id)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == productsCollectionView{
//            let height = scrollView.frame.size.height
//            let contentYoffset = scrollView.contentOffset.y
//            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//            print("distanceFromBottom \(distanceFromBottom)")
//            print("height \(height)")
//            if Int(distanceFromBottom) == Int(height) {
//                isFromBottom = true
//                counter += 1
//            }
//        }
//    }
    
}

extension PharmaciesPageViewController :UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        pharmaciesPageTableView.delegate = self
        pharmaciesPageTableView.dataSource = self
        pharmaciesPageTableView.register(.init(nibName: "RestaurantTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantTypeTableViewCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTypeTableViewCell", for: indexPath) as!
        RestaurantTypeTableViewCell
        cell.titleLabel.text = categories[indexPath.row].name ?? ""
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shadowViewAction()
        selectedCategoryId = String(categories[indexPath.row].id!)
        allLabel.text = categories[indexPath.row].name ?? ""
        if let data = data{
            presnter.getListSupermarktsItems(page: String(counter), orderBy: selectedSort, category: selectedCategoryId, vendorId: String(data.id!))
        }
    }
    
    
}


extension PharmaciesPageViewController: ResturentPagePresnterDelegate{
    func setListSupermarketItems(data: [FavouriteItems]) {
//        if isFromBottom{
//            items.append(contentsOf: data)
//        }else{
            items = data
//        }
        
        productsCollectionView.reloadData()
    }
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
    func setCategories(categries: [Categories]) {
        self.categories = categries
        pharmaciesPageTableView.reloadData()
    }
    
    
    func setListVendorItems(data: [RestaurantItems]) {
        // just for Restaurants
    }
    
    
    func setListOfOffers(data: [RestaurantOffers]) {
        // just for Restaurants
    }
    
    
}
