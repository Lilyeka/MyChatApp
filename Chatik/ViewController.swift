//
//  ViewController.swift
//  Chatik
//
//  Created by Лилия Левина on 11.11.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var hamburgerViewLeadingConstraintt: NSLayoutConstraint!
    @IBOutlet weak var hamburgerBackgroundViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgHamburgerViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var gamburgerBackgroundView: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var messages:[(Bool,String)]? = [(false,"12334454546565656565433453454435344534534"),
                                     (true, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv"),
                                     (false, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv"),
    (false, "qwhqhduiehduehdiuhdiuhfiuehfireuhfireufhireufhierhfiurehhvuhreiuv")]
    
    @IBAction func sendMessage(_ sender: Any) {
        if !textView.text.isEmpty {
            messages?.append((true,textView.text))
            textView.text = ""
            guard let messages =  messages, messages.count > 0 else { return }
            tableView.reloadData() // TODO: reloadRows
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tapOnTheBaseTableView(_ sender: UITapGestureRecognizer) {
        textView.endEditing(true)
        
    }
    @IBAction func tapBgViewAction(_ sender: UITapGestureRecognizer) {
        hideHamburgeView()
    }
    
    @IBAction func swipeToTheLeftAction(_ sender: Any) {
        hideHamburgeView()
    }
    
    @IBAction func swipeToTheRightAction(_ sender: Any) {
        showHamburgerView()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        
        if #available(iOS 11.0, *) {
            self.bottomViewBottomConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        } else { self.bottomViewBottomConstraint.constant = view.safeAreaInsets.bottom }
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded()}
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.bottomViewBottomConstraint.constant =  0
        UIView.animate(withDuration: 0.5){ self.view.layoutIfNeeded() }
    }
    
    private func showHamburgerView() {
        if self.hamburgerViewLeadingConstraintt.constant != 0  {
            bgHamburgerViewTrailing.constant = 380
            self.hamburgerViewLeadingConstraintt.constant = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func hideHamburgeView() {
        if self.hamburgerViewLeadingConstraintt.constant == 0 {
            bgHamburgerViewTrailing.constant = -380
            self.hamburgerViewLeadingConstraintt.constant = -380
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .layoutSubviews, animations: {
                self.view.layoutIfNeeded()})
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let (isUserMessage,message) = messages?[indexPath.row] {
            if isUserMessage {
                let cell = tableView.dequeueReusableCell(
                       withIdentifier: "CellUser",
                       for: indexPath) as! UserMessageTableViewCell
                       cell.messageLabel.text = message
                       return cell
            } else {
                let cell = tableView.dequeueReusableCell(
                   withIdentifier: "Cell",
                   for: indexPath) as! ChatMessageTableViewCell
                   cell.messageLabel.text = message
                   return cell
            }
        }
        let cell = tableView.dequeueReusableCell(
        withIdentifier: "Cell",
        for: indexPath) as UITableViewCell
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

