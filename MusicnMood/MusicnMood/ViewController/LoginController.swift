//
//  LoginController.swift
//  MusicnMood
//
//  Created by WJL on 4/7/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone-6-wallpaper-18.jpg")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Login Success")
            self.performSegue(withIdentifier:"loginGoToMe" , sender: self)
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
