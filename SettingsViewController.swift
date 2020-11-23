//
//  SettingsViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 15.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailLabel: UILabel!
   
    // MARK: - Variables
    var user: ChatUser!
    var imagePicker: ImagePicker!
    var selectedImage: Data?
    var isEditingState = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    // MARK: - IBActions
    @IBAction func userAvatarTapAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.imagePicker.present(from: sender.view!)
    }
    
    @IBAction func changeButtonTappedAction(_ sender: UIButton) {
        if !isEditingState {
            isEditingState = !isEditingState
            sender.setTitle("Сохранить", for: .normal)
            userImageView.isUserInteractionEnabled = true
            userNameTextField.isUserInteractionEnabled = true
            userPasswordTextField.isUserInteractionEnabled = true
        } else {
            let newName = userNameTextField.text ?? ""
            self.updateProfileInfo(withImage: selectedImage, name: newName) { (error) in
                NotificationCenter.default.post(name: NSNotification.Name.userSettingsChangedNotification,
                                                            object: self.user)
            }
            
            if let passwText = userPasswordTextField.text, passwText.count > 0, user.password != passwText {
                Auth.auth().currentUser?.updatePassword(to: passwText) { (error) in
                    NotificationCenter.default.post(name: NSNotification.Name.userSettingsChangedNotification,
                                                    object: self.user)
                }
            }
          
            self.view.endEditing(true)
            self.dismiss(animated: true) 
        }
    }
    
    @IBAction func tapOnSettingsGestureRecogniser(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private methods
    private func setupSubviews() {
        userImageView.isUserInteractionEnabled = false
        userNameTextField.isUserInteractionEnabled = false
        userPasswordTextField.isUserInteractionEnabled = false
        
        if user.avatar != "" {
            let islandRef = Storage.storage().reference(forURL: user.avatar)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let _ = error {
                    print()
                } else if data != nil {
                    let image = UIImage(data: data!)
                    self.userImageView.image = image
                }
            }
        } else {
            self.userImageView.image = UIImage(named: "defaultUser")
        }
        userNameTextField.text = user.name
        userPasswordTextField.text = user.password
        userEmailLabel.text = user.email
    }
    
    private func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        guard let user = Auth.auth().currentUser else {
            callback?(nil)
            return
        }

        if let image = image{
            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).png")

            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
                if let error = error {
                    callback?(error)
                } else {
                    profileImgReference.downloadURL(completion: { (url, error) in
                        if let url = url{
                            self.createProfileChangeRequest(photoUrl: url, name: name, { (error) in
                                callback?(error)
                            })
                        }else{
                            callback?(error)
                        }
                    })
                }
            }
        } else if let name = name {
            self.createProfileChangeRequest(name: name, { (error) in
                callback?(error)
            })
        }else {
            callback?(nil)
        }
    }
    
    private func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
            if let name = name{
                request.displayName = name
            }
            if let url = photoUrl{
                request.photoURL = url
            }
            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
}

// MARK: - ImagePickerDelegate
extension SettingsViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let image = image {
            self.userImageView.image = image
            self.selectedImage = UIImage.pngData(image)()
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
}
