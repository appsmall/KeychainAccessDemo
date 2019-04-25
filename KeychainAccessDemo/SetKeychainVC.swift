//
//  SetKeychainVC.swift
//  KeychainAccessDemo
//
//  Created by apple on 24/04/19.
//  Copyright © 2019 appsmall. All rights reserved.
//

import UIKit
import KeychainSwift


struct Keys {
    static let prefix = "appsmall_"
    static let name = "name"
    static let profileImage = "profileImage"
    static let isAccountPrivate = "isAccountPrivate"
}


class SetKeychainVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var privateAccountSwitch: UISwitch!
    
    // Set keychain object with a key
    let keychain = KeychainSwift(keyPrefix: Keys.prefix)
    
    
    // MARK:- VIEW CONTROLLER LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(updateUI), with: nil, afterDelay: 0.0)
    }
    
    @objc func updateUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = true
    }
    
    // MARK:- IBACTIONS
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        showChooseSourceTypeAlertController()
    }
    
    @IBAction func saveDetailsBtnPressed(_ sender: UIButton) {
        
        // Save profileImage as a data into Keychain
        if let image = profileImageView.image {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                if keychain.set(imageData, forKey: Keys.profileImage, withAccess: KeychainSwiftAccessOptions.accessibleAlways) {
                    print("Image saved successfully")
                }
            }
        }
        
        // Save user name as a string into Keychain
        if let name = nameTextField.text {
            if name != "" {
                if keychain.set(name, forKey: Keys.name, withAccess: KeychainSwiftAccessOptions.accessibleAlways) {
                    print("Name saved successfully")
                }
            }
        }
        
        // Save Switch Value as a bool into Keychain
        let isAccountPrivate = privateAccountSwitch.isOn
        if keychain.set(isAccountPrivate, forKey: Keys.isAccountPrivate, withAccess: KeychainSwiftAccessOptions.accessibleAlways) {
            print("Private account status saved successfully")
        }
        
    }
    
    @IBAction func deleteNameBtnPressed(_ sender: UIButton) {
        
        // Delete only name from the keychain, if it exists
        if keychain.delete(Keys.name) {
            print("Name deleted successfully")
        }
    }
    
    @IBAction func clearKeychainBtnPressed(_ sender: UIButton) {
        
        // Clear all the keychain data of that app
        if keychain.clear() {
            print("Keychain clear successfully")
        }
    }
    
    @IBAction func showKeychainDataBtnPressed(_ sender: UIButton) {
    }

}

// MARK:- IMAGE PICKER DELEGATE METHODS
extension SetKeychainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showChooseSourceTypeAlertController() {
        let photoLibraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
 
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITEXTFIELD DELEGATE METHOD
extension SetKeychainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
