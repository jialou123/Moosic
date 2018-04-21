//
//  MoodScanViewController.swift
//  MusicnMood
//
//  Created by WJL on 4/14/18.
//  Copyright © 2018 Tony Jojan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos

//protocol sendmood {
//    func moodreceived(data:String)
//}

class MoodScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var faceanalysis: UILabel!
    @IBOutlet weak var userface: UIImageView!
    @IBOutlet weak var Moosic: UIButton!
    
    var imagePicker: UIImagePickerController!
    let faceAnalysisModel = FaceAnalysisModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Moosic.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iphone-6-wallpaper-18.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func getmusic(_ sender: Any) {
        performSegue(withIdentifier: "fSToSPT", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fSToSPT"{
            let moodtomusic = segue.destination as! MusicViewController
            var max : Double = 0
            var maxmood : String = ""
            if faceAnalysisModel.anger > max{max = faceAnalysisModel.anger; maxmood = "anger"}
            if faceAnalysisModel.fear > max{max = faceAnalysisModel.fear;maxmood = "fear"}
            if faceAnalysisModel.surprise > max{max = faceAnalysisModel.surprise;maxmood = "surprise"}
            if faceAnalysisModel.contempt > max{max = faceAnalysisModel.contempt;maxmood = "contempt"}
            if faceAnalysisModel.disgust > max{max = faceAnalysisModel.disgust;maxmood = "disgust"}
            if faceAnalysisModel.neutral > max{max = faceAnalysisModel.neutral;maxmood = "neutral"}
            if faceAnalysisModel.happiness > max{max = faceAnalysisModel.happiness;maxmood = "happy"}
            if faceAnalysisModel.sadness > max{max = faceAnalysisModel.sadness;maxmood = "sad"}
            moodtomusic.searchquery = maxmood
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takeFaceScan(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func resetFace(_ sender: UIButton) {
         facemodelreset()
        faceanalysis.text = "Data Reset"
    }
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedimg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userface.contentMode = .scaleToFill
            userface.image = pickedimg
            let image = UIImageJPEGRepresentation(pickedimg, 1)
            let urlStr = "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceAttributes=age,gender,headPose,smile,facialHair,glasses,emotion,hair,makeup,occlusion,accessories,blur,exposure,noise"
            var request = URLRequest(url: URL(string: urlStr)!)
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            request.setValue("e77c9448ff894e999fb06d16a7d2083b", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            request.httpMethod = "POST"
            request.httpBodyStream = InputStream(data: image!)
            //self.testlabel.text = "successsss"
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                guard let data = data, error == nil else {
                    print("error sending request")
                    return
                }
                let faceJson : JSON = JSON(data)
                self.parseJson(json: faceJson)
                print(faceJson)
            }.resume()
    }
    
    picker.dismiss(animated: true, completion: nil)
    sleep(5)
    if faceAnalysisModel.invalid {
        faceanalysis.text = "Invalid Face"
    }
    else{
        faceanalysis.text = "Anger:\(faceAnalysisModel.anger)\n Fear:\(faceAnalysisModel.fear)\n Suprise:\(faceAnalysisModel.surprise)\n Contempt:\(faceAnalysisModel.contempt)\n Disgust:\(faceAnalysisModel.disgust)\n Happiness:\(faceAnalysisModel.happiness)\n Neutral:\(faceAnalysisModel.neutral)\n Sadness:\(faceAnalysisModel.sadness)\n Age:\(faceAnalysisModel.age)\n Gender:\(faceAnalysisModel.gender)\n Bald:\(faceAnalysisModel.bald)Cote"
            self.Moosic.isHidden = false
        
    }
    }
    
    func facemodelreset(){
        faceAnalysisModel.age = 0.0
        faceAnalysisModel.anger = 0.0
        faceAnalysisModel.fear = 0.0
        faceAnalysisModel.surprise = 0.0
        faceAnalysisModel.contempt = 0.0
        faceAnalysisModel.disgust = 0.0
        faceAnalysisModel.happiness = 0.0
        faceAnalysisModel.neutral = 0.0
        faceAnalysisModel.sadness = 0.0
        faceAnalysisModel.gender = ""
        faceAnalysisModel.bald = 0.0
        faceAnalysisModel.invalid = true
    }
    
    func parseJson(json:JSON){
       // self.faceanalysis.text = "Loading..."
        if json[0]["faceId"].string != nil{
        faceAnalysisModel.invalid = false
        let anger = json[0]["faceAttributes"]["emotion"]["anger"].doubleValue
        let fear = json[0]["faceAttributes"]["emotion"]["fear"].doubleValue
        let surprise = json[0]["faceAttributes"]["emotion"]["surprise"].doubleValue
        let contempt = json[0]["faceAttributes"]["emotion"]["contempt"].doubleValue
        let disgust = json[0]["faceAttributes"]["emotion"]["disgust"].doubleValue
        let happiness = json[0]["faceAttributes"]["emotion"]["happiness"].doubleValue
        let neutral = json[0]["faceAttributes"]["emotion"]["neutral"].doubleValue
        let sadness = json[0]["faceAttributes"]["emotion"]["sadness"].doubleValue
        let bald = json[0]["faceAttributes"]["hair"]["bald"].doubleValue
        let age = json[0]["faceAttributes"]["age"].doubleValue
        let gender = json[0]["faceAttributes"]["gender"].stringValue
       faceAnalysisModel.age = age
       faceAnalysisModel.anger = anger
       faceAnalysisModel.fear = fear
       faceAnalysisModel.surprise = surprise
       faceAnalysisModel.contempt = contempt
       faceAnalysisModel.disgust = disgust
       faceAnalysisModel.happiness = happiness
       faceAnalysisModel.neutral = neutral
       faceAnalysisModel.sadness = sadness
       faceAnalysisModel.gender = gender
       faceAnalysisModel.bald = bald
        }
        else{
            //faceanalysis.text = "Invalid Face"
            faceAnalysisModel.invalid = true
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
