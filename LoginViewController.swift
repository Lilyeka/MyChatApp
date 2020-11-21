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
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // TODO - До показа кнопки пароли д.б. проверены на совпадение, и емэйл проверен на правильность
        
        guard let emailField = signUpEmailTextField.text,
            let passwordField = signUpPasswordTextField.text,
            let repeatPasswodField = signUpPasswordRepeatTextField.text else { return }
        if passwordField == repeatPasswodField {
            createUser(email: emailField, password: passwordField)
        } else {
            showErrorAlert(title: "Ошибка совпадения паролей", description: "Введите пароли заново")
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
    
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: email,
                                   password: password){ user, error in
                                    if let error = error, user == nil {
                                        self.showErrorAlert(title: "Sign In Filed", description: error.localizedDescription)
                                    } else {
                                        self.goToChatViewController()
                                    }
                }
            } else {
                self.showErrorAlert(title: "Sign Up Filed", description: error!.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(title: String, description: String) {
           let alert = UIAlertController(title: title,
                                         message: description,
                                         preferredStyle: .alert)
           
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
        case 1:          //регистрация
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
