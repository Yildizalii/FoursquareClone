//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Ali on 8.02.2022.
//

import UIKit
import Parse
class SignUPVC: UIViewController {

    @IBOutlet weak var emailTextLabel: UITextField!
    
    @IBOutlet weak var passwordTextLabel: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func signInButton(_ sender: Any) {
        if emailTextLabel.text == "" && passwordTextLabel.text == "" {
            makeAlert(messageInput: "Email/Password?", titleInput: "Error!")
        }else {
            PFUser.logInWithUsername(inBackground: emailTextLabel.text!, password: passwordTextLabel.text!) { user, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error!", titleInput: "OK")
                }else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                }
            }
        }
    }
    @IBAction func sıgnUpButton(_ sender: Any) {
        if emailTextLabel.text != "" && passwordTextLabel.text != "" {
            let user = PFUser()
            user.username = emailTextLabel.text!
            user.password = passwordTextLabel.text!
            
            user.signUpInBackground { succes, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Error!" , titleInput: "Error!")
                }else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else {
            makeAlert(messageInput: "Email/Pasword?", titleInput: "Error!")
        }
    }
    func makeAlert(messageInput : String , titleInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

