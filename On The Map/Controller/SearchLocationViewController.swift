//
//  SearchLocationViewController.swift
//  On The Map
//
//  Created by Yash Rao on 2/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class searchLocationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    var keyboardOnScreen = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardwillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardwillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromAllNotifications()
    }
    
    
    @IBAction func locationButton(_ sender: Any) {
        geoCodeLocation(location: locationTextField.text!, mediaURL: urlTextField.text!)

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func geoCodeLocation(location: String, mediaURL: String) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        guard (mediaURL != "") else {
            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.emptyURL)
            return
        }
        
        guard (mediaURL.contains("http://")) || (mediaURL.contains("https://")) else {
            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.httpURL)
            return
        }
        
        self.appDelegate.mapString = location
        self.appDelegate.mediauRL = mediaURL
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            guard (error == nil) else {
                MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.locationError)
                self.activityIndicator.stopAnimating()
                return
            }
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let coordinate = location.coordinate
                self.appDelegate.latitude = coordinate.latitude
                self.appDelegate.longitude = coordinate.longitude
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "showLocation", sender: nil)
            }
        }
    }
}
    
extension searchLocationVC {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardwillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= 0.3 * keyboardHeight(notification)
        }
    }
    @objc func keyboardwillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += 0.3 * keyboardHeight(notification)
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
        resignIfFirstResponder(locationTextField)
        resignIfFirstResponder(urlTextField)
    }

    func configureUI() {
        
        self.imageView.image = UIImage(named: "icon_world")
        self.imageView.contentMode = .scaleAspectFill
        self.locationButton.backgroundColor = Constants.UI.LoginColorTop
        self.locationTextField.placeholder = "Enter Location Here"
        self.urlTextField.placeholder = "Enter Media URL here"
        
        configureTextField(locationTextField)
        configureTextField(urlTextField)
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

private extension searchLocationVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
