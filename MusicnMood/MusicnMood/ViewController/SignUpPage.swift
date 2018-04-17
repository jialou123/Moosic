//
//  SignUpPage.swift
//  MusicnMood
//
//  Created by Tony Jojan on 3/28/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit
import Firebase

class SignUpPage: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signup(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: username.text!, password: password.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("registeration success")
                self.performSegue(withIdentifier: "signUpGoToMe", sender: self)
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
