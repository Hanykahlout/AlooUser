//
//  TechnicalSupportViewController.swift
//  Aloo
//
//  Created by Hany Alkahlout on 19/10/2021.
//

import UIKit

class TechnicalSupportViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var reportTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inilization()

    }


    private func inilization(){
        plusImageView.isUserInteractionEnabled = true
        plusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusImageViewAction)))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.transform = .init(rotationAngle: .pi)
        }
    }
    
    @objc private func plusImageViewAction(){
        setImageBy(source: .photoLibrary)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        
    }


}

extension TechnicalSupportViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage.image = editingImage
        }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage.image = orginalImage
        }
        addImageLabel.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    
}
