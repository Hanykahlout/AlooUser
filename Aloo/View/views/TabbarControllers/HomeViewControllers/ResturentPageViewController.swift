//
//  ResturentPageViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 25/09/2021.
//

import UIKit

class ResturentPageViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var offersPageControl: UIPageControl!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet var sortByButtons: [UIButton]!
    @IBOutlet weak var highestStackView: UIStackView!
    @IBOutlet weak var lowestStackView: UIStackView!
    @IBOutlet weak var resturentNameLabel: UILabel!
    @IBOutlet weak var resturentTypeLabel: UILabel!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var mealsTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var categoriesView: UIViewCustomCornerRadius!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    private var counter = 1
    private var isFromBottom = false
    
    
    public var data:ListVendorItems?
    private var orderBy = ""
    private var selectedCategroy = ""
    private var categories = [Categories]()
    private var items = [RestaurantItems]()
    private var offers = [RestaurantOffers]()
    private var presnter = ResturentPagePresnter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initlization()
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpCollectionView()
        setupTableView()
        setUpStacksAction()
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowViewAction)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
            offersPageControl.transform = .init(rotationAngle: .pi)
        }
        setResturentData()
        let vendorId = String(data?.id ?? -1)
        presnter.getCategories(vendorId: vendorId)
        presnter.getListVendorItems(page: String(counter), orderBy: "", category: "", vendorId: vendorId)
    }
    
    private func setResturentData(){
        logoImageView.sd_setImage(with: URL(string: data?.logo ?? ""))
        resturentNameLabel.text = data?.name ?? ""
        minPriceLabel.text = "\(data?.min_price ?? "") SR"
        resturentTypeLabel.text = data?.description ?? ""
    }
    
    private func setUpStacksAction(){
        highestStackView.isUserInteractionEnabled = true
        lowestStackView.isUserInteractionEnabled = true
        highestStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(highestStackViewAction)))
        lowestStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lowestStackViewAction)))
    }
    
    
    @objc private func highestStackViewAction(){
        orderBy = "price_highest"
        sortByButtons[0].isSelected = false
        sortByButtons[1].isSelected = true
    }
    
    @objc private func lowestStackViewAction(){
        orderBy = "price_lowest"
        sortByButtons[0].isSelected = true
        sortByButtons[1].isSelected = false
    }
    
    
    @objc private func shadowViewAction(){
        shadowView.isHidden = true
        categoriesView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "Token") != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "CartViewController") as! CartViewController
            vc.isRestaurant = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: LoginUserViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func listAction(_ sender: Any) {
        categoriesView.isHidden = false
        shadowView.isHidden = false
    }
    
}

extension ResturentPageViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    private func setUpCollectionView(){
        offersCollectionView.delegate = self
        offersCollectionView.dataSource = self
        offersCollectionView.register(.init(nibName: "ResturantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResturantCollectionViewCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResturantCollectionViewCell", for: indexPath) as!
        ResturantCollectionViewCell
        cell.productImageView.sd_setImage(with: URL(string: offers[indexPath.row].img ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as! MealDetailsViewController
        vc.itemId = String(offers[indexPath.row].id!)
        vc.isOffer = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: offersCollectionView.bounds.width, height: offersCollectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        offersPageControl.currentPage = Int(pageNumber)
    }
    
}

extension ResturentPageViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func setupTableView(){
        mealsTableView.delegate = self
        mealsTableView.dataSource = self
        mealsTableView.register(.init(nibName: "ResturentPageTableViewCell", bundle: nil), forCellReuseIdentifier: "ResturentPageTableViewCell")
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mealsTableView{
            return items.count
        }
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mealsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResturentPageTableViewCell", for: indexPath) as!
            ResturentPageTableViewCell
            cell.setData(data: items[indexPath.row])
            return cell
        }
        let cell = UITableViewCell()
        cell.selectionStyle = .gray
        cell.textLabel!.font = UIFont(name: "Tajawal", size: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0.1568627451, green: 0.2196078431, blue: 0.2705882353, alpha: 1)
        cell.textLabel?.text = categories[indexPath.row].name ?? ""
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mealsTableView{
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as! MealDetailsViewController
            vc.itemId = String(items[indexPath.row].id!)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            counter = 1
            selectedCategroy = categories[indexPath.row].id == nil ? "" : "\(categories[indexPath.row].id!)"
            presnter.getListVendorItems(page: String(counter), orderBy: orderBy, category: selectedCategroy, vendorId: String(data?.id ?? -1))
            categoriesView.isHidden = true
            shadowView.isHidden = true
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mealsTableView{
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if Int(distanceFromBottom) == Int(height) {
                isFromBottom = true
                counter += 1
                presnter.getListVendorItems(page: String(counter), orderBy: orderBy, category: selectedCategroy, vendorId: String(data?.id ?? -1))
                
            }
        }
    }
    
    
    
}

extension ResturentPageViewController: ResturentPagePresnterDelegate{
    func setListSupermarketItems(data: [FavouriteItems]) {
        // for super market
    }
    
    func setListOfOffers(data: [RestaurantOffers]) {
        offers = data
        offersCollectionView.reloadData()
        offersPageControl.numberOfPages = data.count
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func setListVendorItems(data: [RestaurantItems]) {
        if isFromBottom{
            items.append(contentsOf: data)
        }else{
            items = data
        }
        mealsTableView.reloadData()
    }
    
    func setCategories(categries: [Categories]) {
        self.categories = categries
        categoriesTableView.reloadData()
    }
    
}

