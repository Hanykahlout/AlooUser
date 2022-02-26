//
//  RestaurantsViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 23/09/2021.
//

import UIKit
import GoogleMaps

class RestaurantsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var lowestStackView: UIStackView!
    @IBOutlet weak var highestStackView: UIStackView!
    @IBOutlet weak var rateStackView: UIStackView!
    
    @IBOutlet weak var kitchenTypesTableView: UITableView!
    @IBOutlet weak var resturantTableView: UITableView!
    @IBOutlet weak var restaurantsTypeTableView: UITableView!
    
    @IBOutlet weak var selectView: UIViewCustomCornerRadius!
    @IBOutlet weak var typesView: UIViewCustomCornerRadius!
    @IBOutlet weak var deliveryAddressesView: UIViewCustomCornerRadius!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet var sortByRaduioButtons: [UIButton]!
    
    @IBOutlet weak var resturentTypeButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var currentLocationButton: GraidentButton!
    
    
    private let googleMap = GMSMapView()
    
    private var counter = 1
    private var isFromBottom = false
    
    private var locationManager = CLLocationManager()
    private var currentLocation:CLLocationCoordinate2D?
    private var data = [ListVendorItems]()
    private var restaurantTypes = [CitiesInfo]()
    private var selectedRestaurantType:CitiesInfo?
    private var kitchenTypes = [CitiesInfo]()
    private var selectedKitchenTypes:CitiesInfo?
    private var selectedOrderType = ""
    private var selectedPlaceId = ""
    private var allPlaces = [Places]()
    
    private let presnter = RestaurantsPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initlization()
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpStackViewsActions()
        setUpLocationRequest()
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectShadowView)))
        showhideView(view: shadowView)
        showhideView(view: deliveryAddressesView)
        setUpTableViews()
    }
    
    func setUpStackViewsActions(){
        lowestStackView.isUserInteractionEnabled = true
        highestStackView.isUserInteractionEnabled = true
        rateStackView.isUserInteractionEnabled = true
        
        lowestStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lowestStackViewAction)))
        highestStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(highestStackViewAction)))
        rateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateStackViewAction)))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        if UserDefaults.standard.string(forKey: "Token") != nil{
            currentLocationButton.setTitle(NSLocalizedString("Add Address", comment: ""), for: .normal)
        }else{
            currentLocationButton.setTitle(NSLocalizedString("Use Current Location", comment: ""), for: .normal)
        }
        presnter.getAddress()
        presnter.getKitchenTypes()
        presnter.getRestaurantTypes()
    }
    
    
    private func setUpLocationRequest(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func showhideView(view:UIView){
        view.isHidden = !view.isHidden
    }
    
    private func selectIndex(i:Int){
        for index in 0..<sortByRaduioButtons.count{
            if index == i{
                sortByRaduioButtons[index].isSelected = true
                continue
            }
            sortByRaduioButtons[index].isSelected = false
        }
    }
    
    
    @objc private func didSelectShadowView(){
        if deliveryAddressesView.isHidden{
            shadowView.isHidden = true
            selectView.isHidden = true
            typesView.isHidden = true
        }
    }
    
    
    @objc private func lowestStackViewAction(){
        selectIndex(i: 0)
        selectedOrderType = "min_price_lowest"
    }
    
    
    @objc private func highestStackViewAction(){
        selectIndex(i: 2)
        selectedOrderType = "min_price_highest"
    }
    
    @objc private func rateStackViewAction(){
        selectIndex(i: 1)
        selectedOrderType = "rate"
    }
    
    
    @IBAction func selectAction(_ sender: Any) {
        showhideView(view: shadowView)
        showhideView(view: selectView)
    }
    
    
    @IBAction func resturentTypeAction(_ sender: Any) {
        showhideView(view: shadowView)
        showhideView(view: typesView)
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
    
    
    @IBAction func userCurrentLocationAction(_ sender: Any) {
        if currentLocationButton.titleLabel!.text! == NSLocalizedString("Use Current Location", comment: ""){
            showhideView(view: shadowView)
            showhideView(view: deliveryAddressesView)
            if let currentLocation = currentLocation{
                isFromBottom = false
                presnter.getListOfGuestVendors(vendorId: "3", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude), orderId: "", kitchenType: "", restaurantType: "")
            }
        }else{
            navigationController?.pushViewController(AddressViewController(), animated: true)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}


extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource{
    private func setUpTableViews(){
        resturantTableView.delegate = self
        resturantTableView.dataSource = self
        resturantTableView.register(.init(nibName: "ResturantTableViewCell", bundle: nil), forCellReuseIdentifier: "ResturantTableViewCell")
        
        addressTableView.delegate = self
        addressTableView.dataSource = self
        addressTableView.register(.init(nibName: "DeliveryAddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressesTableViewCell")
        
        kitchenTypesTableView.delegate = self
        kitchenTypesTableView.dataSource = self
        restaurantsTypeTableView.delegate = self
        restaurantsTypeTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resturantTableView{
            return data.count
        }else if tableView == kitchenTypesTableView{
            return kitchenTypes.count
        }else if tableView == restaurantsTypeTableView{
            return restaurantTypes.count
        }
        return allPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resturantTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResturantTableViewCell", for: indexPath) as! ResturantTableViewCell
            cell.setData(data: data[indexPath.row])
            return cell
        }else if tableView == addressTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressesTableViewCell") as! DeliveryAddressesTableViewCell
            cell.setData(data: allPlaces[indexPath.row])
            return cell
        }else{
            let cell = UITableViewCell()
            cell.selectionStyle = .gray
            cell.textLabel!.font = UIFont(name: "Tajawal", size: 15)
            cell.textLabel?.textColor = #colorLiteral(red: 0.1568627451, green: 0.2196078431, blue: 0.2705882353, alpha: 1)
            cell.textLabel!.text = tableView == kitchenTypesTableView ? kitchenTypes[indexPath.row].name ?? "" : restaurantTypes[indexPath.row].name ?? ""
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        counter = 1
        isFromBottom = false
        if tableView == kitchenTypesTableView{
            selectView.isHidden = true
            shadowView.isHidden = true
            selectedKitchenTypes = kitchenTypes[indexPath.row]
            selectButton.setTitle(selectedKitchenTypes?.name ?? "", for: .normal)
            if UserDefaults.standard.string(forKey: "Token") == nil{
                if let currentLocation = currentLocation{
                    let restaurantType = selectedRestaurantType?.id == nil ? "" : String(selectedRestaurantType!.id!)
                    
                    presnter.getListOfGuestVendors(vendorId: "3", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude),  orderId: selectedOrderType , kitchenType: String(selectedKitchenTypes!.id!), restaurantType: restaurantType)
                }
            }else{
                
                let restaurantType = selectedRestaurantType?.id == nil ? "" : String(selectedRestaurantType!.id!)
                presnter.getListOfUserVendors(vendorId: "3", page: String(counter), placeId:selectedPlaceId , orderId: selectedOrderType, kitchenType: String(selectedKitchenTypes!.id!), restaurantType: restaurantType)
            }
        }else if tableView == resturantTableView{
            let vc = ResturentPageViewController()
            vc.data = data[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }else if tableView == restaurantsTypeTableView{
            typesView.isHidden = true
            shadowView.isHidden = true
            selectedRestaurantType = restaurantTypes[indexPath.row]
            resturentTypeButton.setTitle(selectedRestaurantType?.name ?? "", for: .normal)
            if UserDefaults.standard.string(forKey: "Token") == nil{
                if let currentLocation = currentLocation{
                    let kitchenType:String = selectedKitchenTypes?.id == nil ? "" : String(selectedKitchenTypes!.id!)
                    
                    presnter.getListOfGuestVendors(vendorId: "3", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude), orderId: selectedOrderType, kitchenType: kitchenType, restaurantType: String(selectedRestaurantType!.id!))
                }
            }else{
                let kitchenType:String = selectedKitchenTypes?.id == nil ? "" : String(selectedKitchenTypes!.id!)
                
                presnter.getListOfUserVendors(vendorId: "3", page: String(counter), placeId: selectedPlaceId, orderId: selectedOrderType, kitchenType: kitchenType, restaurantType: String(selectedRestaurantType!.id!))
                
            }
        }else{
            selectedPlaceId = String(allPlaces[indexPath.row].id ?? -1)
            UserDefaults.standard.setValue(allPlaces[indexPath.row].name ?? "", forKey: "SelectedPlaceName")
            UserDefaults.standard.setValue(allPlaces[indexPath.row].id ?? -1, forKey: "SelectedPlaceId")
            presnter.getListOfUserVendors(vendorId: "3", page: String(counter), placeId: selectedPlaceId , orderId: "", kitchenType: "", restaurantType: "")
            deliveryAddressesView.isHidden = true
            shadowView.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if Int(distanceFromBottom) == Int(height) {
            isFromBottom = true
            counter += 1
            if let _ = UserDefaults.standard.string(forKey: "Token"){
                let restaurantType = selectedRestaurantType?.id == nil ? "" : String(selectedRestaurantType!.id!)
                let kitchenType:String = selectedKitchenTypes?.id == nil ? "" : String(selectedKitchenTypes!.id!)
                
                presnter.getListOfUserVendors(vendorId: "3", page: String(counter), placeId: selectedPlaceId, orderId: selectedOrderType, kitchenType: kitchenType, restaurantType: restaurantType)
            }else{
                if let currentLocation = currentLocation{
                    presnter.getListOfGuestVendors(vendorId: "3", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude), orderId: "", kitchenType: "", restaurantType: "")
                }
            }
        }
    
    }
    
    
    
}

extension RestaurantsViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil{
            if let location  = locations.first{
                currentLocation = location.coordinate
                showGoogleMap(withCoordinate: location.coordinate)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error
    }
    
    private func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
        googleMap.frame = mapView.bounds
        googleMap.camera = camera
        mapView.addSubview(googleMap)
        let userMarker = GMSMarker()
        userMarker.position = coordinate
        userMarker.iconView = UIImageView(image: #imageLiteral(resourceName: "current-user-location"))
        userMarker.map = googleMap
    }
    
}

extension RestaurantsViewController:RestaurantsPresnterDelegate{
    func setPlaces(data: [Places]) {
        allPlaces = data
        addressTableView.reloadData()
    }
    
    func setRestaurantTypes(data: [CitiesInfo]) {
        restaurantTypes = data
        restaurantsTypeTableView.reloadData()
    }
    
    func setKitchenTypes(data: [CitiesInfo]) {
        kitchenTypes = data
        kitchenTypesTableView.reloadData()
    }
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func vendorsData(data: ListVendorData) {
        if isFromBottom{
            self.data.append(contentsOf: data.items ?? [])
        }else{
            self.data = data.items ?? []
        }
        
        
        resturantTableView.reloadData()
    }
    
    
}
