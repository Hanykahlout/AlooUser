//
//  AddressViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 28/09/2021.
//

import UIKit
import GoogleMaps
class AddressViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detrmindInMapView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var addNewLocationView: UIView!
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var deliveryAddressesTableView: UITableView!
    @IBOutlet weak var locationAddressTextField: UITextField!
    
    
    private var locationManager = CLLocationManager()
    private var currentLocation:CLLocationCoordinate2D?
    private let googleMap = GMSMapView()
    private let presnter = AddressPresnter()
    private var allPlaces = [Places]()
    private var currentIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.getAddress()
        
    }
    
    
    
    private func initlization(){
        presnter.delegate =  self
        googleMap.delegate = self
        setUpLocationRequest()
        setUpTableView()
    }
    
    
    private func setUpLocationRequest(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        if addNewLocationView.isHidden{
            deliveryAddressesTableView.isHidden = true
            addNewLocationView.isHidden = false
        }else{
            deliveryAddressesTableView.isHidden = false
            addNewLocationView.isHidden = true
            
            // Add Location Here
            if !deliveryAddressesTableView.isHidden{
                if !addressNameTextField.text!.isEmpty && !locationAddressTextField.text!.isEmpty{
                    if let currentLocation = currentLocation{
                        presnter.addNewPlaces(name: addressNameTextField.text!,location_name: locationAddressTextField.text!,location: currentLocation)
                    }
                }else{
                    showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is an empty fields !!", comment: ""))
                }
            }
        }
    }
}


extension AddressViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        deliveryAddressesTableView.delegate = self
        deliveryAddressesTableView.dataSource = self
        
        deliveryAddressesTableView.register(.init(nibName: "DeliveryAddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressesTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressesTableViewCell") as! DeliveryAddressesTableViewCell
        cell.setData(data: allPlaces[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [self] (_, _, completionHandler) in
            // delete the item here
            currentIndexPath = indexPath
            presnter.deletePlace(id: String(allPlaces[indexPath.row].id!))
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "ic_delete_sweep_24px")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8784313725, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
}


extension AddressViewController:CLLocationManagerDelegate,GMSMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.first{
            currentLocation = location.coordinate
            showGoogleMap(withCoordinate: currentLocation!)
            
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
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMap.clear()
        currentLocation = coordinate
        showGoogleMap(withCoordinate: coordinate)
    }
    
}



extension AddressViewController:AddressPresnterDelegate{
    func removePlace() {
        if let index = currentIndexPath{
            allPlaces.remove(at: index.row)
            deliveryAddressesTableView.deleteRows(at: [index], with: .automatic)
        }
    }
    
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
    func setAllAddress(data: UserPlacesData) {
        if let places = data.places{
            allPlaces = places
            reloadAddress()
        }
    }
    
    
    func reloadAddress() {
        deliveryAddressesTableView.reloadData()
    }
    
}




