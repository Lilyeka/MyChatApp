//
//  SettingsViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 15.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    var isEditingState = false

    var user: ChatUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {
        userImageView.isUserInteractionEnabled = false
        userNameTextField.isUserInteractionEnabled = false
        userPasswordTextField.isUserInteractionEnabled = false
         
        userImageView.image = user.avatar != "" ? UIImage(named: user.avatar) : UIImage(named: "defaultUser")
        userNameTextField.text = user.name
        userPasswordTextField.text = user.password
        userEmailLabel.text = user.email
    }
    
    @IBAction func userAvatarTapAction(_ sender: UITapGestureRecognizer) {
        print("Выбрать новый аватар")
    }
    @IBAction func changeButtonTappedAction(_ sender: UIButton) {
        if !isEditingState {
            isEditingState = !isEditingState
            sender.setTitle("Сохранить", for: .normal)
            userImageView.isUserInteractionEnabled = true
            userNameTextField.isUserInteractionEnabled = true
            userPasswordTextField.isUserInteractionEnabled = true
        } else {
            //user.avatar
            user.name = userNameTextField.text ?? ""
            user.password = userPasswordTextField.text ?? ""
        }
        
    }
    
}
