//
//  GetKeychainVC.swift
//  KeychainAccessDemo
//
//  Created by apple on 24/04/19.
//  Copyright © 2019 appsmall. All rights reserved.
//

import UIKit
import KeychainSwift

class GetKeychainVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountPrivateLabel: UILabel!
    
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
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getDataBtnPressed(_ sender: UIButton) {
        
        if keychain.lastResultCode != noErr {
            // Some error occured
            print(keychain.lastResultCode)
        }
        else {
            // No error
            
            // Get user data from keychain
            if let imageData = keychain.getData(Keys.profileImage) {
                let image = UIImage(data: imageData)
                profileImageView.image = image
            }
            
            if let name = keychain.get(Keys.name) {
                nameLabel.text = name
            }
            
            if let isPrivateAccount = keychain.getBool(Keys.isAccountPrivate) {
                if isPrivateAccount {
                    accountPrivateLabel.text = "true"
                }
                else {
                    accountPrivateLabel.text = "false"
                }
            }
        }
    }
    
}
