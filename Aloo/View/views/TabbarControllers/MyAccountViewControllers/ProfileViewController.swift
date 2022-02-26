//
//  ProfileViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 27/09/2021.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileImageImageView: UIImageView!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var addImageImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassowdTextField: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cititesView: UIViewCustomCornerRadius!
    @IBOutlet weak var genderBottomSheetView: UIViewCustomCornerRadius!
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    
    
    
    private let presnter = ProfilePresnter()
    private var allCities = [CitiesInfo]()
    private var viewGestureRecognizer:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
        presnter.getUserData()
        presnter.getCities()
    }
    
    
    private func initlization(){
        setTableView()
        presnter.delegate = self
        setUpViews()
    }
    
    
    private func setUpViews(){
        maleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleViewAction)))
        femaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleViewAction)))
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shadowViewAction)))
        viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(viewGestureRecognizer)
        genderView.isUserInteractionEnabled = true
        cityView.isUserInteractionEnabled = true
        genderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickGender)))
        cityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickCity)))
        addImageImageView.isUserInteractionEnabled = true
        addImageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImageAction)))
    }
    
    
    
    
    @objc private func addImageAction(){
        setImageBy(source: .photoLibrary)
    }
    
    
    @objc private func keyboardDismiss(){
        nameTextField.endEditing(true)
        emailTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
        passwordTextField.endEditing(true)
        confirmPassowdTextField.endEditing(true)
    }
    
    @objc private func didClickGender(){
        keyboardDismiss()
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.shadowView.isHidden = false
            self.genderBottomSheetView.isHidden = false
        })
    }
    
    
    @objc private func didClickCity(){
        keyboardDismiss()
        view.removeGestureRecognizer(viewGestureRecognizer)
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve,animations: {
            self.shadowView.isHidden = false
            self.cititesView.isHidden = false
        })
    }
    
    
    @objc private func shadowViewAction(){
        view.addGestureRecognizer(viewGestureRecognizer)
        shadowView.isHidden = true
        cititesView.isHidden = true
        genderBottomSheetView.isHidden = true
    }
    
    
    @objc private func maleViewAction(){
        genderLabel.text = "male"
    }
    
    
    @objc private func femaleViewAction(){
        genderLabel.text = "female"
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let phone = phoneNumberTextField.text!
        let gender = genderLabel.text!
        let city = cityLabel.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPassowdTextField.text!
        let image = profileImageImageView.image
        if presnter.validation(name: name, phoneNumber: phone, gender: gender, region: city){
            let user = UserData(name: name, mobile: phone, city: GeneralActions.shard.getCityNumber(allCities: allCities,name: city), gender: gender, password: password, confirmPassword: confirmPassword, email: email, img: image)
            presnter.setUserData(user: user)
        }else{
            showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("There is an empty field!", comment: ""))
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension ProfileViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageImageView.image = editingImage
        }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageImageView.image = orginalImage
        }
        addImageLabel.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    private func setTableView(){
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
        
        cityLabel.text = allCities[indexPath.row].name ?? ""
        shadowViewAction()
    }
}



extension ProfileViewController: ProfilePresnterDelegate{
    func setCitiesData(data: CitiesBasedData) {
        if let data = data.cities{
            allCities = data
            citiesTableView.reloadData()
        }
    }
    
    func goBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
    
    func setUserData(data: UserDataResponseData) {
        if let image = data.img{
            addImageLabel.isHidden = true
            profileImageImageView.sd_setImage(with: URL(string: image))
        }
        nameTextField.text = data.name ?? ""
        emailTextField.text = data.email ?? ""
        phoneNumberTextField.text = data.phone ?? ""
        cityLabel.text = data.city?.name_en ?? ""
        genderLabel.text = data.gender ?? ""
    }
    
    
}

