//
//  SignUpViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 11/10/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var termsRadioButtonImageView: UIImageView!
    @IBOutlet weak var termsStackView: UIStackView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var selectCityView: UIViewCustomCornerRadius!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var genderBottomSheetView: UIViewCustomCornerRadius!
    
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var preferNotToSayView: UIView!
    
    
    private let presnter = SignUpPresnter()
    private var allCities = [CitiesInfo]()
    private var viewGestureRecognizer:UITapGestureRecognizer!
    private var selectedCities = ""
    private var selectedGeneder = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    private func initlization(){
        viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        setUpTableView()
        presnter.delegate = self
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.getCities()
    }
    
    private func setUpViews(){
        view.addGestureRecognizer(viewGestureRecognizer)
        maleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
        femaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        otherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(otherViewAction)))
        preferNotToSayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(preferNotToSayViewAction)))
        
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowViewAction)))
        genderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(genderViewAction)))
        regionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(regionViewAction)))
        termsStackView.isUserInteractionEnabled = true
        termsStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsStackViewAction)))
    }
    
    
    
    @objc private func otherViewAction(){
        selectedGeneder = "other"
        genderLabel.text = NSLocalizedString("other", comment: "")
        shadowViewAction()
    }
    
    
    @objc private func preferNotToSayViewAction(){
        selectedGeneder = "prefer not to say"
        genderLabel.text = NSLocalizedString("prefer not to say", comment: "")
        shadowViewAction()
    }
    
    
    @objc private func maleAction(){
        selectedGeneder = "male"
        genderLabel.text = NSLocalizedString("male", comment: "")
        shadowViewAction()
    }
    
    
    @objc private func femaleAction(){
        selectedGeneder = "female"
        genderLabel.text = NSLocalizedString("female", comment: "")
        shadowViewAction()
    }
    
    @objc private func shadowViewAction(){
        view.addGestureRecognizer(viewGestureRecognizer)
        genderBottomSheetView.isHidden = true
        selectCityView.isHidden = true
        shadowView.isHidden = true
    }
    
    @objc private func viewAction(){
        usernameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
        passwordTextField.endEditing(true)
        confirmPasswordTextField.endEditing(true)
    }
    
    
    @objc private func genderViewAction(){
        viewAction()
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.genderBottomSheetView.isHidden = false
            self.shadowView.isHidden = false
        })
    }
    
    
    @objc private func regionViewAction(){
        viewAction()
        view.removeGestureRecognizer(viewGestureRecognizer)
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.selectCityView.isHidden = false
            self.shadowView.isHidden = false
        })
    }
    
    
    @objc private func termsStackViewAction(){
        if termsRadioButtonImageView.image == #imageLiteral(resourceName: "SelectedPath"){
            termsRadioButtonImageView.image = #imageLiteral(resourceName: "check-icon")
        }else{
            termsRadioButtonImageView.image = #imageLiteral(resourceName: "SelectedPath")
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        if termsRadioButtonImageView.image == #imageLiteral(resourceName: "SelectedPath"){
            let name = usernameTextField.text!
            let phoneNumber = phoneNumberTextField.text!
            let password = passwordTextField.text!
            let confirmPassword = confirmPasswordTextField.text!
            
            let region = regionLabel.text!
            if presnter.validation(name: name, phoneNumber: phoneNumber ,password: password,confirmPassword: confirmPassword, gender: selectedGeneder, region: region){
                let user = User(name: name, mobile: phoneNumber, city: GeneralActions.shard.getCityNumber(allCities: allCities,name: region), gender: selectedGeneder, password: password, confirmPassword: confirmPassword)
                presnter.SignUp(user: user)
            }else{
                GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is Empty Fields!!", comment: ""))
            }
        }else{
            GeneralActions.shard.showAlert(viewController: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You have to accept terms to use the aloo app", comment: ""))
        }
    }
    
}



extension SignUpViewController:UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        
        citiesTableView.register(.init(nibName: "RestaurantSortTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantSortTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSortTableViewCell", for: indexPath) as! RestaurantSortTableViewCell
        cell.selectRadioButtonImageView.isHidden = true
        cell.typeLabel.text = allCities[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        regionLabel.text = allCities[indexPath.row].name ?? ""
        shadowViewAction()
    }
    
    
}


extension SignUpViewController:SignUpPresnterDelegate{
    func setCitiesData(data: CitiesBasedData) {
        if let data = data.cities{
            allCities = data
            citiesTableView.reloadData()
        }
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    func goToPhoneVerifcation() {
        GeneralActions.shard.sendFCMTokenToServer()
        let vc = ActivatePhoneNumberViewController()
        vc.phoneNumber = phoneNumberTextField.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
