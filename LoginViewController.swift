//
//  LoginViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 16.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var regView: UIView!
    @IBOutlet weak var logView: UIView!
    @IBOutlet weak var loginTabBarItem: UITabBarItem!
    @IBOutlet weak var signUpTabBarItem: UITabBarItem!
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpPasswordRepeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = loginTabBarItem
        addKeyboardObservers()
        //addAuthObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard
            let email = signInEmailTextField.text,
            let password = signInPasswordTextField.text,
            email.count > 0,
            password.count > 0
            else { return }
            signInUser(email: email, password: password, writeToken: false)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let emailField = signUpEmailTextField.text,
            let passwordField = signUpPasswordTextField.text,
            let repeatPasswodField = signUpPasswordRepeatTextField.text else { return }
        if passwordField == repeatPasswodField {
            createUser(email: emailField, password: passwordField)
        } else {
            showErrorAlert(title: "Ошибка", description: "Пароли не совпадают. Введите пароли заново")
        }
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification)  {
        
    }
    
    @objc func keyboardWillHide(notification: Notification)  {
        
    }
    
    private func signInUser(email: String, password: String, writeToken: Bool) {
        Auth.auth().signIn(withEmail: email,
                           password: password){ authResult, error in
                            if let error = error, authResult == nil {
                                self.showErrorAlert(title: "Sign In Filed", description: error.localizedDescription)
                            } else {
                                let uuid = UUID().uuidString
                                UserDefaults.standard.set(uuid, forKey: "userToken")
                                if writeToken {
                                   //записали токен
                                    let ref = Database.database().reference(withPath: "userTokens")
                                    let firUser = authResult!.user
                                    ref.child(uuid).setValue(firUser.uid)
                                   //Создать юзера и сохранить в таблице users
                                    var user = ChatUser(avatar: "", name: "", email: email, password: password)
                                     let refUser = Database.database().reference(withPath: "user-Items")
                                    refUser.child(firUser.uid).setValue(user.toAnyObject())
                                    
                                }
                                self.goToChatViewController()
                            }
        }
    }
    
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                self.signInUser(email: email, password: password, writeToken: true)
            } else {
                self.showErrorAlert(title: "Sign Up Filed", description: error!.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addAuthObserver() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.goToChatViewController()
            }
        }
    }
    
    private func goToChatViewController() {
        self.performSegue(withIdentifier: "goToChatSegue", sender: nil)
        self.signInEmailTextField.text = nil
        self.signInPasswordTextField.text = nil
        self.signUpEmailTextField.text = nil
        self.signUpPasswordTextField.text = nil
        self.signUpPasswordRepeatTextField.text = nil
    }
}

extension LoginViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:   //регистрация
            logView.isHidden = true
            regView.isHidden = false
        case 0:   //вход
            logView.isHidden = false
            regView.isHidden = true
        default:
            break
        }
    }
}
