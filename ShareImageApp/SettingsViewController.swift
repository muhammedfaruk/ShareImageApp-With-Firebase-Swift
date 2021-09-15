//
//  SettingsViewController.swift
//  ShareImageApp
//
//  Created by Muhammed Faruk Söğüt on 14.09.2021.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func signOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        }catch{
            print("ERROR WHEN SIGN OUT")
        }
        performSegue(withIdentifier: "toMainVC", sender: nil)
    }
    

}
