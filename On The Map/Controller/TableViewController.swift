//
//  TableViewController.swift
//  On The Map
//
//  Created by Yash Rao on 1/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableNavBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadTableView()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        MasterNetwork.sharedInstance().logoutSession(controller: self)
        MasterNetwork.sharedInstance().segueToLoginVC(self)
    }
    
    @IBAction func segueTosearchVC(_ sender: Any) {
        MasterNetwork.sharedInstance().segueToSearchVC(self)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        loadTableView()
    }
    
    func loadTableView() {
        
        MasterNetwork.sharedInstance().getRequestStudentLocationTest() { (success, error) in
            if success {
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.GETError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        
        if UsersData.dataArray.count < 100 {
            return UsersData.dataArray.count
        }
        else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfo", for: indexPath)
        let student = UsersData.dataArray[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = UsersData.dataArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let app = UIApplication.shared
        if MasterNetwork.sharedInstance().ValidateURL(student.mediaURL) {
            app.open((URL(string: student.mediaURL))!, options: [:], completionHandler: nil)
        } else {
            MasterNetwork.sharedInstance().alertError(self, error: self.appDelegate.errorMessages.webError)
        }
    }
}

