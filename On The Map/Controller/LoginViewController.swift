//
//  LoginViewController.swift
//  On The Map
//
//  Created by Yash Rao on 1/21/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate  {
    

    var keyboardOnScreen = false
    var appDelegate: AppDelegate!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var linkToUdacity: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardwillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardwillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        
    }    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
    func sendToUdacitySignup() {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

    func loginWithUdacity() {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if MasterNetwork.sharedInstance().isInternetAvailable() {
            MasterNetwork.sharedInstance().loginToUdacity(username: loginTextField.text!, password: passwordTextField.text!) {success, errorString, error in
                if success {
                    MasterNetwork.sharedInstance().getUserData(userID: self.appDelegate.userID!) {success, error in
                        performUIUpdatesOnMain {
                            if success {
                                MasterNetwork.sharedInstance().getSingleUser(uniqueKey: self.appDelegate.userID!) { (success, error) in
                                    performUIUpdatesOnMain {
                                        if success {
                                            self.activityIndicator.stopAnimating()
                                            self.performSegue(withIdentifier: "loginToMap", sender: nil)
                                        } else {
                                            self.activityIndicator.stopAnimating()
                                            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.LoginSelfError)
                                        }
                                    }
                                }
                            } else {
                                performUIUpdatesOnMain {
                                    self.activityIndicator.stopAnimating()
                                    MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.CallDataError)
                                }
                            }
                        }
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.LoginCredentialsError)
                    }
                }
            }
            
        } else {
            self.activityIndicator.stopAnimating()
            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.connectionError)
        }

    }

    @IBAction func loginPressed(_ sender: Any) {
        loginWithUdacity()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        sendToUdacitySignup()
    }
}


extension LoginViewController {
    
    //Will be used to give up priority in textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardwillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= 0.25 * keyboardHeight(notification)
        }
    }
    @objc func keyboardwillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += 0.25 * keyboardHeight(notification)
        }
    }
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(loginTextField)
        resignIfFirstResponder(passwordTextField)
    }
}

private extension LoginViewController {
    
    func configureUI() {
        self.loginButton.backgroundColor = Constants.UI.LoginColorTop
        self.logoImageView.contentMode = .scaleAspectFit
        self.loginTextField.placeholder = "Email"
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.isSecureTextEntry = true
        
        configureTextField(loginTextField)
        configureTextField(passwordTextField)
        
    }
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.delegate = self
    }
}

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

