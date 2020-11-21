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
}

class HamburgerViewController: UIViewController {
     //MARK: - IBOutlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFirstNameLettersLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - Variables
    var user: ChatUser!
    var delegate:HamburgerViewControllerDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(self.userSettingsChangedNotificationAction(_:)), name: NSNotification.Name.userSettingsChangedNotification, object: nil)
    }
     // MARK: - Private methods
    private func setupViews() {
        userImageView.layer.cornerRadius = 45.0
        userImageView.clipsToBounds = true
        userFirstNameLettersLabel.text = ""
        if user.avatar != "" {
            userImageView.image = UIImage(named: user.avatar)
        } else {
            userImageView.image = UIImage(named: "defaultUser")
            if user.name != "", user.name.count > 0 {
                userFirstNameLettersLabel.text = String(user.name.prefix(1))
            }
        }
        userNameLabel.text = user.name
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
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(nil, forKey: "userToken")
          } catch (let error) {
            print("Auth sign out failed: \(error)")
          }
        }
    }
    
    // MARK: - Notification
    @objc func userSettingsChangedNotificationAction(_ notification: Notification?) {
        setupViews()
    }
}
