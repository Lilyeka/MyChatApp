//
//  HamburgerViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 11.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit
import Firebase

protocol HamburgerViewControllerDelegate {
    func openSettingsVCButtonTapped()
    func exitButtonTapped()
}

class HamburgerViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFirstNameLettersLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - Variables
    var uid: String!
    var user: ChatUser!
    var delegate:HamburgerViewControllerDelegate?
    
    let usersRef = Database.database().reference(withPath: "user-Items")
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadUser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userSettingsChangedNotificationAction(_:)), name: NSNotification.Name.userSettingsChangedNotification, object: nil)
    }
    
    private func loadUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            let avatar = ""
            if user.photoURL != nil {
                let islandRef = Storage.storage().reference(forURL: user.photoURL!.absoluteString)
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
                if user.displayName != "", user.displayName!.count > 0 {
                    self.userFirstNameLettersLabel.text = String(user.displayName!.prefix(1))
                }
            }
            let name = user.displayName ?? "Пользователь № \(user.uid)"
            self.userNameLabel.text = name
            let email = user.email ?? ""
            self.user = ChatUser(avatar: avatar, name: name, email: email, password: "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HamburgerViewDidAppear")
    }
    
    // MARK: - Private methods
    private func setupViews() {
        userImageView.layer.cornerRadius = 45.0
        userImageView.clipsToBounds = true
        userFirstNameLettersLabel.text = ""
    }
    
    // IBActions
    @IBAction func swipeGestureRecogniserAction(_ sender: UISwipeGestureRecognizer) {
    }
    
    @IBAction func settingsBtnAction(_ sender: UIButton) {
        delegate?.openSettingsVCButtonTapped()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        secondVc.user = user
        present(secondVc, animated: true, completion: nil)
    }
    
    @IBAction func exitBtnAction(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {return}
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            do {
                try Auth.auth().signOut()
                // self.dismiss(animated: true, completion: nil)
                // self.parent?.dismiss(animated: true, completion: nil)
                self.delegate?.exitButtonTapped()
                UserDefaults.standard.set(nil, forKey: "userToken")
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
    
    // MARK: - Notification
    @objc func userSettingsChangedNotificationAction(_ notification: Notification?) {
        loadUser()
    }
    
    private func showErrorAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
