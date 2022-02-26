//
//  PharmaciesVC.swift
//  Aloo
//  Created by macbook on 9/27/21.
//

import UIKit
import GoogleMaps

class PharmaciesVC: UIViewController {
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var highestView: GraidentView!
    @IBOutlet weak var lowestView: GraidentView!
    @IBOutlet weak var sortByButton: UIButton!
    
    @IBOutlet weak var sortByView: UIViewCustomCornerRadius!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet var displayTable: UITableView!
    @IBOutlet weak var deliveryAddressesView: UIViewCustomCornerRadius!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var currentLocationButton: GraidentButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    private let googleMap = GMSMapView()
    private var locationManager = CLLocationManager()
    private var currentLocation:CLLocationCoordinate2D?
    
    private var selectedOrderBy = ""
    private var selectedPlaceId = ""
    
    private var counter = 1
//    private var isFromBottom = false
//    private var per_page = 0
    
    
    private var data = [ListVendorItems]()
    private var listOfResturantsType = [CitiesInfo]()
    private var listOfKitchenTypes = [CitiesInfo]()
    private var listOfPlaces = [Places]()
    private let presnter = RestaurantsPresnter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        let isMarket = UserDefaults.standard.bool(forKey: "isMarket")
        bgImageView.image =  isMarket ? #imageLiteral(resourceName: "Group 4") : #imageLiteral(resourceName: "ph-bg-image")
        headerLabel.text = isMarket ? "SuperMarkets" : "Pharmacies"
        if UserDefaults.standard.string(forKey: "Token") != nil{
            currentLocationButton.setTitle(NSLocalizedString("Add Address", comment: ""), for: .normal)
        }else{
            currentLocationButton.setTitle(NSLocalizedString("Use Current Location", comment: ""), for: .normal)
        }
        presnter.getKitchenTypes()
        presnter.getRestaurantTypes()
        presnter.getAddress()
    }
    
    private func initlization(){
        presnter.delegate = self
        self.shadowView.isHidden = false
        self.deliveryAddressesView.isHidden = false
        setUpLocationRequest()
        setUpTableView()
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowAction)))
        highestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(highestViewAction)))
        lowestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lowestViewAction)))
    }
    
    
    
    
    private func setUpLocationRequest(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @objc private func shadowAction(){
        if deliveryAddressesView.isHidden{
            shadowView.isHidden = true
            sortByView.isHidden = true
        }
    }
    
    
    @objc private func highestViewAction(){
        sortByButton.setTitle(NSLocalizedString("From High To Low", comment: ""), for: .normal)
        selectedOrderBy = "min_price_highest"
        counter = 1
        if UserDefaults.standard.string(forKey: "Token") == nil{
            if let location = currentLocation{
                presnter.getListOfGuestVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), lon: String(location.longitude), lat: String(location.latitude), orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
            }
        }else{
            presnter.getListOfUserVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), placeId: selectedPlaceId , orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
        }
        shadowAction()
    }
    
    @objc private func lowestViewAction(){
        sortByButton.setTitle(NSLocalizedString("From Low To High", comment: ""), for: .normal)
        selectedOrderBy = "min_price_lowest"
        counter = 1
        if UserDefaults.standard.string(forKey: "Token") == nil{
            if let location = currentLocation{
                presnter.getListOfGuestVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), lon: String(location.longitude), lat: String(location.latitude), orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
            }
        }else{
            presnter.getListOfUserVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), placeId: selectedPlaceId , orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
        }
        shadowAction()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isMarket")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userCurrentLocationAction(_ sender: Any) {
        if currentLocationButton.titleLabel!.text! == NSLocalizedString("Use Current Location", comment: ""){
            shadowView.isHidden = true
            deliveryAddressesView.isHidden = true
            if UserDefaults.standard.string(forKey: "Token") == nil {
                if let currentLocation = currentLocation{
                    presnter.getListOfGuestVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude), orderId: "", kitchenType: "", restaurantType: "")
                }
            }
        }else{
            navigationController?.pushViewController(AddressViewController(), animated: true)
        }
    }
    
    
    @IBAction func sortByAction(_ sender: Any) {
        sortByView.isHidden = false
        shadowView.isHidden = false
    }
    
    
    
}

extension PharmaciesVC : UITableViewDataSource,UITableViewDelegate{
    private func setUpTableView(){
        displayTable.delegate = self
        displayTable.dataSource = self
        
        displayTable.register(.init(nibName: "PharmaciesVCTableViewCell", bundle: nil), forCellReuseIdentifier: "PharmaciesVCTableViewCell")
        
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(.init(nibName: "DeliveryAddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressesTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == placesTableView{
            return listOfPlaces.count
        }
        return data.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == displayTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PharmaciesVCTableViewCell", for: indexPath) as! PharmaciesVCTableViewCell
            cell.setData(data: data[indexPath.row])
//            if indexPath.row == data.count - 1{
//                print("per_page \(per_page)")
//                if per_page > data.count{
//                    isFromBottom = true
//                    counter += 1
//                    if let _ = UserDefaults.standard.string(forKey: "Token"){
//                        presnter.getListOfUserVendors(vendorId: "3", page: String(counter), placeId: selectedPlaceId, orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
//                    }else{
//                        if let currentLocation = currentLocation{
//                            presnter.getListOfGuestVendors(vendorId: "3", page: String(counter), lon: String(currentLocation.longitude), lat: String(currentLocation.latitude), orderId: selectedOrderBy, kitchenType: "", restaurantType: "")
//                        }
//                    }
//                }
//            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressesTableViewCell") as! DeliveryAddressesTableViewCell
        cell.setData(data: listOfPlaces[indexPath.row])
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == placesTableView{
            shadowView.isHidden = true
            deliveryAddressesView.isHidden = true
            selectedPlaceId = String(listOfPlaces[indexPath.row].id!)
            presnter.getListOfUserVendors(vendorId: UserDefaults.standard.bool(forKey: "isMarket") ? "1" : "2", page: String(counter), placeId: String(listOfPlaces[indexPath.row].id!), orderId: "", kitchenType: "", restaurantType: "")
        }else{
            let vc = PharmaciesPageViewController()
            vc.data = data[indexPath.row]
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == displayTable{
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if Int(distanceFromBottom) == Int(height) {
                
            }
        }
    }
    
    
}

extension PharmaciesVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.first{
            currentLocation = location.coordinate
            showGoogleMap(withCoordinate: location.coordinate)
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

extension PharmaciesVC:RestaurantsPresnterDelegate{
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func vendorsData(data: ListVendorData) {
//        per_page = data.per_page ?? 0
//        if isFromBottom{
//            self.data.append(contentsOf: data.items ?? [])
//        }else{
            self.data = data.items ?? []
//        }
        displayTable.reloadData()
    }
    
    func setRestaurantTypes(data: [CitiesInfo]) {
        // there is no Restaurant Types in SuperMarkes and Pharmacies
    }
    
    func setKitchenTypes(data: [CitiesInfo]) {
        // there is no Kitchen Types in SuperMarkes and Pharmacies
    }
    
    func setPlaces(data: [Places]) {
        listOfPlaces = data
        placesTableView.reloadData()
    }
    
}
