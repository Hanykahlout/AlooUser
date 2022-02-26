//
//  ProductDetailsViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 08/10/2021.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var numberOfProductLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsPageControl: UIPageControl!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var similarProductsCollectionView: UICollectionView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var addToCartButton: GraidentButton!
    
    public var id:String!
    public var isEdit = false
    private var similarData = [Similar]()
    private var imagesData = [String]()
    private let presnter = ProductDetailsPresnter()
    
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
        bgImageView.image = UserDefaults.standard.bool(forKey: "isMarket") ? #imageLiteral(resourceName: "Group 4") : #imageLiteral(resourceName: "ph-bg-image")
        if isEdit{
            addToCartButton.setTitle("Update", for: .normal)
            presnter.getItemForEdit(id: id)
        }else{
            addToCartButton.setTitle("Add To Cart", for: .normal)
            presnter.getVendorItem(id: id)
        }
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpCollectionViews()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    
    
    @IBAction func favoraiteAction(_ sender: UIButton) {
        if sender.isSelected{
            presnter.deleteFavorite(id: id)
        }else{
            presnter.addFavorite(id: id)
        }
    }
    
    
    @IBAction func plusAction(_ sender: Any) {
        
       let number = Int(numberOfProductLabel.text!)!
       let result = number + 1
       if result <= 10{
           numberOfProductLabel.text = "\(result)"
       }else{
           GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("You cannot add more than 10 items", comment: ""), message: "")
       }
    }
    
    
    @IBAction func minAction(_ sender: Any) {
        let number = Int(numberOfProductLabel.text!)!
         let result = number - 1
         if result != 0 {
             numberOfProductLabel.text = "\(result)"
         }else{
             GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("You cannot add less than 1 item", comment: ""), message: "")
         }
    }
    
    
    @IBAction func addToCartAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "Token") != nil{
            if isEdit{
                presnter.editItem(id: id, amount: numberOfProductLabel.text!)
            }else{
                presnter.addToCart(itemId: id, amount: numberOfProductLabel.text!)
            }
        }else{
            let nav = UINavigationController(rootViewController: LoginUserViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
        
    }
    
    
}

extension ProductDetailsViewController:UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    private func setUpCollectionViews(){
        similarProductsCollectionView.delegate = self
        similarProductsCollectionView.dataSource = self
        similarProductsCollectionView.register(.init(nibName: "ProductsSimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductsSimilarCollectionViewCell")
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(.init(nibName: "ResturantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResturantCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarProductsCollectionView {
            return similarData.count
        }
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similarProductsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsSimilarCollectionViewCell", for: indexPath) as! ProductsSimilarCollectionViewCell
            cell.setData(data: similarData[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResturantCollectionViewCell", for: indexPath) as! ResturantCollectionViewCell
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productImageView.sd_setImage(with: URL(string: imagesData[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarProductsCollectionView{
            if let id = similarData[indexPath.row].id{
                let vc = ProductDetailsViewController()
                vc.id = String(id)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productsCollectionView{
            return .init(width: productsCollectionView.frame.width, height: productsCollectionView.frame.height)
        }
        return .init(width: 125, height: 136)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        productsPageControl.currentPage = Int(pageNumber)
    }
    
}

extension ProductDetailsViewController: ProductDetailsPresnterDelegate{
    func setEditingItemData(data: CartItems) {
        placeImageView.sd_setImage(with: URL(string: data.item?.img ?? ""))
        productNameLabel.text = data.item?.name ?? ""
        priceLabel.text = "\(data.item?.price ?? "") \(NSLocalizedString("SR", comment: ""))"
        weightLabel.text = "\(data.item?.amount ?? 0) \(data.item?.amount_type ?? "")"
        imagesData = data.item?.images ?? []
        productsPageControl.numberOfPages = imagesData.count
        similarData.removeAll()
        productsCollectionView.reloadData()
        similarProductsCollectionView.reloadData()
        favButton.isHidden = true
        numberOfProductLabel.text = String(data.amount ?? 1)
    }
    
    func changeFavoriteButtonStatus(isSelected: Bool) {
        favButton.isSelected = isSelected
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func setData(data: SuperMarketVendorItem) {
        placeImageView.sd_setImage(with: URL(string: data.img ?? ""))
        productNameLabel.text = data.name ?? ""
        priceLabel.text = "\(data.price ?? "") \(NSLocalizedString("SR", comment: ""))"
        weightLabel.text = "\(data.amount ?? 0) \(data.amount_type ?? "")"
        imagesData = data.images ?? []
        productsPageControl.numberOfPages = imagesData.count
        similarData = data.similar ?? []
        productsCollectionView.reloadData()
        similarProductsCollectionView.reloadData()
        favButton.isHidden = false
        favButton.isSelected = data.is_favorite ?? false
    }
    
    
}
