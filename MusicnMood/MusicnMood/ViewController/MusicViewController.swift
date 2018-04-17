//
//  MusicViewController.swift
//  MusicnMood
//
//  Created by WJL on 4/13/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit
class MusicViewController:
    
UIViewController {

    @IBOutlet weak var spotify: UIButton!
    
    @IBAction func spotifylogin(_ sender: UIButton) {
        var loginURL = SPTAuth.loginURL(forClientId: "2cf1d030727646deb8d901a1f8e7a1aa", withRedirectURL: NSURL(string: "Moosic://returnafterlogin")! as URL, scopes: [SPTAuthStreamingScope], responseType:"token")
        UIApplication.shared.openURL(loginURL!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
