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
    
    var uuid: String = {
        return UUID().uuidString
    }()
                               
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = loginTabBarItem
        addKeyboardObservers()
        addAuthObserver()
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
            signInUser(email: email, password: password)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let emailField = signUpEmailTextField.text,
            let passwordField = signUpPasswordTextField.text,
            let repeatPasswodField = signUpPasswordRepeatTextField.text else {
                showErrorAlert(title: "Ошибка", description: "Не все поля заполнены.")
                return
        }
        if passwordField == repeatPasswodField {
            createUser(email: emailField, password: passwordField)
        } else {
            showErrorAlert(title: "Ошибка", description: "Пароли не совпадают. Введите пароли заново.")
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
    
    private func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email,
                           password: password){ authResult, error in
                            if let error = error, authResult == nil {
                                self.showErrorAlert(title: "Sign In Filed", description: error.localizedDescription)
                            } else {
                                self.goToChatViewController(uid: authResult!.user.uid)
                            }
        }
    }
    
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                //записали токен в память приложения на телефоне
                UserDefaults.standard.set(self.uuid, forKey: "userToken")
                
                //записали токен и id юзера
                let ref = Database.database().reference(withPath: "userTokens")
                let firUser = authResult!.user
                ref.child(self.uuid).setValue(firUser.uid)
                
                //Создать юзера и сохранить в таблице users
                var user = ChatUser(avatar: "", name: "Пользователь №\(firUser.uid)", email: email, password: password)
                let refUser = Database.database().reference(withPath: "user-Items")
                refUser.child(firUser.uid).setValue(user.toAnyObject())
                
                //вход
                self.signInUser(email: email, password: password)
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
        if let token = UserDefaults.standard.string(forKey: "userToken") {
            Auth.auth().addStateDidChangeListener() { auth, user in
                      if user != nil {
                          self.goToChatViewController(uid: user!.uid)
                      }
                  }
        }
      
    }
    
    private func goToChatViewController(uid: String) {
        self.performSegue(withIdentifier: "goToChatSegue", sender: uid)
        self.signInEmailTextField.text = nil
        self.signInPasswordTextField.text = nil
        self.signUpEmailTextField.text = nil
        self.signUpPasswordTextField.text = nil
        self.signUpPasswordRepeatTextField.text = nil
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToChatSegue" {
//            guard let object = sender as? String else { return }
//            let dvc = segue.destination as! ViewController
//            //dvc.uid = object
//        }
//    }
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
