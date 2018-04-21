//
//  MeViewController.swift
//  MusicnMood
//
//  Created by WJL on 4/20/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var userpic: UIImageView!
    let imgpicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone-6-wallpaper-18.jpg")!)
        self.useremail.text = Auth.auth().currentUser?.email
        let url = Auth.auth().currentUser?.photoURL
        if url == nil{
            self.userpic.image = UIImage(named: "images.png")
        }
        else{
        let data = try? Data(contentsOf: url!)
        self.userpic.image = UIImage(data: data!)
        }
//        self.userpic.image = Auth.auth().currentUser?.photoURL
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            
            performSegue(withIdentifier: "signout", sender: self)
        }catch{
            print("Error while sign out")
        }
    }
    
    @IBAction func picuserpic(_ sender: UIButton) {
        imgpicker.delegate = self
        imgpicker.allowsEditing = true
        imgpicker.sourceType = .photoLibrary
        present(imgpicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var seletedimg:UIImage?
        
        if let pickedimg = info[UIImagePickerControllerEditedImage] as? UIImage {
            seletedimg = pickedimg
        }else if let pickedimg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            seletedimg = pickedimg
        }
        userpic.contentMode = .scaleToFill
        userpic.image = seletedimg
        
        let storageref = Storage.storage().reference().child("myImg.png")
        if let uploaddata = UIImagePNGRepresentation(seletedimg!){
           
            storageref.putData(uploaddata, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                let changerequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changerequest?.photoURL = metadata?.downloadURL()
                changerequest?.commitChanges(completion: { (error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                })
            }
            
        }
        imgpicker.dismiss(animated: true, completion: nil)
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
