//
//  LoginViewController.swift
//  GigApp
//
//  Created by Lambda_School_Loaner_167 on 10/2/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import UIKit

enum LoginType: Int {
    case signUp
    case singIn
}

class LoginViewController: UIViewController {

    
//    MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logintypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
//    MARK: - PROPERTIES
    var gigController: GigController!
    var loginType: LoginType = .signUp
    
    
//     MARK: - Actions
    
    @IBAction func segmentedControlSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .singIn
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        guard let username = userNameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else { return }
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            signUp(with: user)
        } else {
            signIn(with: user)
        }
    }
    
    
    
//    MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signUp(with user: User) {
        gigController?.signUp(with: user) { (error) in
            if let error = error {
                NSLog("Error occurred during sign up: \(error)")
            } else {
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType = .singIn
                        self.logintypeSegmentedControl.selectedSegmentIndex = self.loginType.rawValue
                        self.signInButton.setTitle("Sign In", for: .normal)
                    }
                }
            }
        }
    }
    
    func signIn(with user: User) {
            gigController?.signIn(with: user) { (error) in
            if let error = error {
            NSLog("Error occurred when signing in user: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
