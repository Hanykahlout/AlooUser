//
//  MealDetailsViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 25/09/2021.
//

import UIKit

class MealDetailsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addIngredientsIntArrowButton: UIButton!
    @IBOutlet weak var drinkTypeArrowButton: UIButton!
    
    @IBOutlet weak var otherAddtionsArrowButton: UIButton!
    
    @IBOutlet weak var addIngredientsHeightConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var drinkTypeHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var otherAddtionsHeightConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var bigSizeButton: UIButton!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var middleSizeButton: UIButton!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var smallLabel: UILabel!
    
    @IBOutlet weak var addIngredientsTableView: UITableView!
    @IBOutlet weak var drinkTypeTableView: UITableView!
    @IBOutlet weak var otherAddtionsTableView: UITableView!
    @IBOutlet weak var numberOfMealsLabel: UILabel!
    @IBOutlet weak var numberOfCartMealsLabel: UILabel!
    @IBOutlet weak var addToCartButton: GraidentButton!
    
    
    public var isEdit = false
    private var isSelectionFromTableView = false
    public var itemId = ""
    public var isOffer = false
    private var options = [OptionalsInfo]()
    private var drinkTypes = [Drinks]()
    private var otherAddtions = [Drinks]()
    private var selectedSize = "M"
    private var selectedWith = [String]()
    private var selectedWithout = [String]()
    private var selectedDrinks = [Int]()
    private var selectedExtras = [Int]()
    
    private let presnter = MealDetailsPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    private func initlization(){
        presnter.delegate = self
        setUpTableViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        if isEdit{
            presnter.getItemForEdit(id: String(itemId))
            cartButton.isHidden = true
            addToCartButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        }else{
            if isOffer{
                presnter.getOffer(id: String(itemId))
                cartButton.isHidden = false
                addToCartButton.setTitle(NSLocalizedString("Add To Cart", comment: ""), for: .normal)
            }else{
                presnter.getItem(id: String(itemId))
                cartButton.isHidden = false
                addToCartButton.setTitle(NSLocalizedString("Add To Cart", comment: ""), for: .normal)
            }
        }
    }
    
    
    private func selectSmall(){
        bigSizeButton.isSelected = false
        middleSizeButton.isSelected = false
        smallButton.isSelected = true
        selectedSize = "S"
    }
    
    private func selectMid(){
        bigSizeButton.isSelected = false
        middleSizeButton.isSelected = true
        smallButton.isSelected = false
        selectedSize = "M"
    }
    
    private func selectBig(){
        bigSizeButton.isSelected = true
        middleSizeButton.isSelected = false
        smallButton.isSelected = false
        selectedSize = "B"
    }
    
    
    @IBAction func addIngredientsArrowAction(_ sender: UIButton) {
        if sender.transform == .init(rotationAngle: .pi){
            sender.transform = .init(rotationAngle: 0)
            self.addIngredientsHeightConstrant.constant = CGFloat((self.options.count * 50) + 60)
            self.addIngredientsTableView.isHidden = false
            
        }else{
            
            sender.transform = .init(rotationAngle: .pi)
            self.addIngredientsTableView.isHidden = true
            self.addIngredientsHeightConstrant.constant = 60
        }
    }
    
    
    
    @IBAction func drinkTypeArrowAction(_ sender: UIButton) {
        if sender.transform == .init(rotationAngle: .pi){
            
            
            sender.transform = .init(rotationAngle: 0)
            self.drinkTypeHeightConstrant.constant = CGFloat((self.drinkTypes.count * 50) + 60)
            self.drinkTypeTableView.isHidden = false
            
        }else{
            
            sender.transform = .init(rotationAngle: .pi)
            self.drinkTypeTableView.isHidden = true
            self.drinkTypeHeightConstrant.constant = 60
            
        }
    }
    
    
    
    @IBAction func otherAddtionsArrowAction(_ sender: UIButton) {
        if sender.transform == .init(rotationAngle: .pi){
            sender.transform = .init(rotationAngle: 0)
            self.otherAddtionsHeightConstrant.constant = CGFloat((self.otherAddtions.count * 50) + 60)
            self.otherAddtionsTableView.isHidden = false
        }else{
            sender.transform = .init(rotationAngle: .pi)
            self.otherAddtionsTableView.isHidden = true
            self.otherAddtionsHeightConstrant.constant = 60
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        let number = Int(numberOfMealsLabel.text!)!
        let result = number - 1
        if result != 0 {
            numberOfMealsLabel.text = "\(result)"
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("You cannot add less than 1 meal", comment: ""), message: "")
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        let number = Int(numberOfMealsLabel.text!)!
        let result = number + 1
        if result <= 10{
            numberOfMealsLabel.text = "\(result)"
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("You cannot add more than 10 meals", comment: ""), message: "")
        }
        
    }
    
    
    @IBAction func smallSizeAction(_ sender: UIButton) {
        selectSmall()
    }
    
    @IBAction func middleSizeAction(_ sender: UIButton) {
        selectMid()
    }
    
    @IBAction func bigSizeAction(_ sender: UIButton) {
        selectBig()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        
        selectedWithout.removeAll()
        for option in options{
            for item in selectedWith{
                if option.option != item{
                    selectedWithout.append(option.option)
                }
            }
        }
        if isEdit{
            presnter.editItem(id: String(itemId), amount: numberOfMealsLabel.text!, size: selectedSize, with: selectedWith, without: selectedWithout, drinks: selectedDrinks, extras: selectedExtras)
        }else{
            presnter.addToCart(itemId: itemId , amount: numberOfMealsLabel.text!, with: selectedWith, without: selectedWithout, size: selectedSize , drinks: selectedDrinks, extras: selectedExtras)
        }
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "Token") != nil{
            let vc = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            vc.isRestaurant = true
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: LoginUserViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    
    
}

extension MealDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func setUpTableViews(){
        addIngredientsTableView.delegate = self
        drinkTypeTableView.delegate = self
        otherAddtionsTableView.delegate = self
        
        addIngredientsTableView.dataSource = self
        drinkTypeTableView.dataSource = self
        otherAddtionsTableView.dataSource = self
        
        addIngredientsTableView.register(.init(nibName: "MealsAddtionsTableViewCell", bundle: nil), forCellReuseIdentifier: "MealsAddtionsTableViewCell")
        drinkTypeTableView.register(.init(nibName: "MealsAddtionsTableViewCell", bundle: nil), forCellReuseIdentifier: "MealsAddtionsTableViewCell")
        otherAddtionsTableView.register(.init(nibName: "MealsAddtionsTableViewCell", bundle: nil), forCellReuseIdentifier: "MealsAddtionsTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case addIngredientsTableView:
            return options.count
        case drinkTypeTableView:
            return drinkTypes.count
        case otherAddtionsTableView:
            return otherAddtions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealsAddtionsTableViewCell", for: indexPath) as! MealsAddtionsTableViewCell
        switch tableView {
        case addIngredientsTableView:
            cell.setData(data: options[indexPath.row])
        case drinkTypeTableView:
            cell.setData(data: drinkTypes[indexPath.row])
        case otherAddtionsTableView:
            cell.setData(data: otherAddtions[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MealsAddtionsTableViewCell
        cell.selectButton.isSelected = !cell.selectButton.isSelected
        
        if cell.selectButton.isSelected{
            switch tableView {
            case addIngredientsTableView:
                selectedWith.append(options[indexPath.row].option)
            case drinkTypeTableView:
                selectedDrinks.append(drinkTypes[indexPath.row].id!)
            case otherAddtionsTableView:
                selectedExtras.append(otherAddtions[indexPath.row].id!)
            default:
                break
            }
        }else{
            switch tableView {
            case addIngredientsTableView:
                isSelectionFromTableView = true
                for i in 0..<selectedWith.count {
                    if selectedWith[i] == options[indexPath.row].option {
                        selectedWith.remove(at: i)
                        break
                    }
                }
            case drinkTypeTableView:
                for i in 0..<selectedDrinks.count {
                    if selectedDrinks[i] == drinkTypes[indexPath.row].id! {
                        selectedDrinks.remove(at: i)
                        break
                    }
                }
            case otherAddtionsTableView:
                for i in 0..<selectedExtras.count {
                    if selectedExtras[i] == otherAddtions[indexPath.row].id! {
                        selectedExtras.remove(at: i)
                        break
                    }
                }
            default:
                break
            }
        }
        
    }
    
}


extension MealDetailsViewController:MealDetailsPresnterDelegate{
    func setEditingItemData(data: CartItems) {
        mealImageView.sd_setImage(with: URL(string: data.item?.img ?? ""))
        mealNameLabel.text = data.item?.name ?? ""
        descriptionLabel.text = data.item?.description ?? ""
        caloriesLabel.text = "\(data.item?.calories ?? "") \(NSLocalizedString("calories", comment: ""))"
        priceLabel.text = "\(data.item?.price ?? "") \(NSLocalizedString("SR", comment: ""))"
        
        bigLabel.text = "\(NSLocalizedString("Big", comment: ""))\n\(data.item?.sizes?.big ?? "0") SR"
        middleLabel.text = "\(NSLocalizedString("Medium", comment: ""))\n\(data.item?.sizes?.medium ?? "0") SR"
        smallLabel.text = "\(NSLocalizedString("Small", comment: ""))\n\(data.item?.sizes?.small ?? "0") SR"
        
        options.removeAll()
        for option in data.item?.optionals ?? []{
            options.append(.init(option: option, isSelected: false))
        }
        
        drinkTypes = data.item?.drinks ?? []
        otherAddtions = data.item?.extras ?? []
        
        addIngredientsTableView.reloadData()
        drinkTypeTableView.reloadData()
        otherAddtionsTableView.reloadData()
        addIngredientsHeightConstrant.constant = CGFloat((options.count * 50) + 60 )
        drinkTypeHeightConstrant.constant = CGFloat((drinkTypes.count * 50) + 60)
        otherAddtionsHeightConstrant.constant = CGFloat((otherAddtions.count * 50) + 60)
        
        if let data = data.data{
            setSelectedItems(selectedData: data)
        }
        numberOfMealsLabel.text = String(data.amount ?? 1)
    }
    
    
    private func setSelectedItems(selectedData:CartData){
        selectSize(size: selectedData.size ?? "")
        
        selectedWith.removeAll()
        for optionIndex in 0..<options.count{
            if let with = selectedData.with{
                for selection in with{
                    if selection == options[optionIndex].option{
                        selectedWith.append(options[optionIndex].option)
                        options[optionIndex].isSelected = true
                    }
                }
            }else{
                break
            }
        }
        
        selectedDrinks.removeAll()
        for optionIndex in 0..<drinkTypes.count{
            if let drinks = selectedData.drinks{
                for selection in drinks{
                    if selection.name! == drinkTypes[optionIndex].name!{
                        selectedDrinks.append(drinkTypes[optionIndex].id!)
                        drinkTypes[optionIndex].isSelected = true
                    }
                }
            }else{
                break
            }
        }
        
        selectedExtras.removeAll()
        for optionIndex in 0..<otherAddtions.count{
            if let extras = selectedData.extras{
                for selection in extras{
                    if selection.name! == otherAddtions[optionIndex].name!{
                        selectedExtras.append(otherAddtions[optionIndex].id!)
                        otherAddtions[optionIndex].isSelected = true
                    }
                }
            }else{
                break
            }
        }
        
        addIngredientsTableView.reloadData()
        drinkTypeTableView.reloadData()
        otherAddtionsTableView.reloadData()
        
    }
    
    
    
    private func selectSize(size:String){
        switch size {
        case "Big":
            selectBig()
        case "Medium":
            selectMid()
        case "Small":
            selectSmall()
        default:
            break
        }
    }
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func setResponseData(data: FavouriteItems) {
        mealImageView.sd_setImage(with: URL(string: data.img ?? ""))
        mealNameLabel.text = data.name ?? ""
        descriptionLabel.text = data.description ?? ""
        
        priceLabel.text = "\(data.price ?? 0) \(NSLocalizedString("SR", comment: ""))"
        
        if isOffer{
            caloriesLabel.text = "\(data.stringAmount ?? "") \(NSLocalizedString("calories", comment: ""))"
            options.removeAll()
            for option in data.with ?? []{
                options.append(.init(option: option, isSelected: false))
            }
        }else{
            caloriesLabel.text = "\(data.amount ?? 0) \(data.amount_type ?? "")"
            options.removeAll()
            for option in data.optionals ?? []{
                options.append(.init(option: option, isSelected: false))
            }
        }
        
        
        bigLabel.text = "\(NSLocalizedString("Big", comment: ""))\n\(data.sizes?.big ?? "0") SR"
        middleLabel.text = "\(NSLocalizedString("Medium", comment: ""))\n\(data.sizes?.medium ?? "0") SR"
        smallLabel.text = "\(NSLocalizedString("Small", comment: ""))\n\(data.sizes?.small ?? "0") SR"
        
        
        drinkTypes = data.drinks ?? []
        otherAddtions = data.extras ?? []
        
        addIngredientsTableView.reloadData()
        drinkTypeTableView.reloadData()
        otherAddtionsTableView.reloadData()
        
        addIngredientsHeightConstrant.constant = CGFloat((options.count * 50) + 60 )
        drinkTypeHeightConstrant.constant = CGFloat((drinkTypes.count * 50) + 60)
        otherAddtionsHeightConstrant.constant = CGFloat((otherAddtions.count * 50) + 60)
        
        
    }
    
    
}


