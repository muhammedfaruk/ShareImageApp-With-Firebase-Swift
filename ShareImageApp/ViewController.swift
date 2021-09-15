//
//  ViewController.swift
//  ShareImageApp
//
//  Created by Muhammed Faruk Söğüt on 12.09.2021.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var userPassword = ""
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginClicked(_ sender: Any) {
    
        if emailTextField.text! != "" && passwordTextField.text! != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                
                if error != nil {
                    
                    //User is not exist
                    self.alertMessage(title: "Warning!", message: error?.localizedDescription ?? "Error")
                    
                }
                else{
                    //Existing User
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            alertMessage(title: "Warning", message: "Please enter your Email and Password!")
        }
        
        
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
       
        if passwordTextField.text! != "" && emailTextField.text! != ""{
           
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                
                if error != nil {
                    //There is an error !!
                    self.alertMessage(title: "Warning!", message: error?.localizedDescription ?? "Error")
                }
                else{
                    //User Created
                    print("user created")
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        }
        else {
            alertMessage(title: "Warning", message: "Please enter your Email and Password!")
        }
        
        
        
       
    }
    
    func alertMessage(title : String, message : String){
       
        let uıAlert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertOKButton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        uıAlert.addAction(alertOKButton)
        self.present(uıAlert, animated: true, completion: nil)
    
    }
    
}

