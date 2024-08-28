//
//  VideoPostVC.swift
//  Fametale
//
//  Created by Callsoft on 05/07/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import DropDown
import AVKit
import AVFoundation

class VideoPostVC: UIViewController,UITextViewDelegate {

    
    
    //MARK:- OUTLETS
    //MARK:-
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewCategoryDropDown: UIView!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtFeildCatagory: UITextField!
    @IBOutlet weak var txtFeildHashTag: UITextField!
    @IBOutlet weak var imgViewThumbnail: UIImageView!
    
    //MARK:- VARIABLE
    //MARK:-
    let validation:Validation = Validation.validationManager() as! Validation
    var imagdata = Data()
    var videoData = Data()
    var WebserviceConnection =  AlmofireWrapper()
     let categoryDropDown = DropDown()
    var videoURL: URL!
    
    
    var videoImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        initailSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden =  true
    }
    


    //MARK:- METHODS
    //MARK:
    func validationForChangePassword()->Void{
    
        var message = ""
        
        if !validation.validateBlankField(txtFeildCatagory.text!){
            message = "Please fill catagory"
        }
        else if !validation.validateBlankField(txtFeildHashTag.text!){
            message = "Please select hashtag"
        }
            
        else if txtViewDescription.text == "Write Your Description..."{
            message = "Please enter description"
        }
        
            
        else if !validation.validateBlankField(txtViewDescription.text!) || txtViewDescription.text == "Write Your Description..."{
            message = "Please enter description"
        }
       
        if message != "" {
            
            
            _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
            
        }else{
            
           postVideoApi()
            
        }
        
        
    }
    
    func initailSetUp(){
 
        
        self.txtViewDescription.text = "Write Your Description..."
        
        self.txtViewDescription.textColor = UIColor.lightGray
        self.txtViewDescription.delegate = self
        
        
        imagdata = UIImagePNGRepresentation(videoImage)!
        print(imagdata)
        let image = UIImage(data: imagdata)
        
          imgViewThumbnail.image = image
        
        
    }
    
    override func viewDidLayoutSubviews()
    {
        if #available(iOS 11.0, *)
        {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        else
        {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    
    
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(self.txtViewDescription == textView){
            
            self.txtViewDescription.text = nil
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.txtViewDescription == textView){
            
            if self.txtViewDescription.text.isEmpty {
                
                self.txtViewDescription.text = "Write Your Description..."
                
                self.txtViewDescription.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (self.txtViewDescription.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 150
    }
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnPostTapped(_ sender: Any) {
        
        validationForChangePassword()
        
    }
    
    
    @IBAction func btnCategoryTapped(_ sender: Any) {
        self.categoryDropDown.anchorView = viewCategoryDropDown
        categoryDropDown.dataSource = ["1","2","3","4","5","6","7","8","9","10"]
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtFeildCatagory.text = item
        }
        
        categoryDropDown.show()
    }
    
    
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        
        let avPlayerViewController = AVPlayerViewController()
        var avPlayer:AVPlayer? = nil
//        let url = URL(string: videoUrl)
        avPlayer = AVPlayer.init(url: videoURL!)
        avPlayerViewController.player = avPlayer
        print("downloadUrl obtained and set")
        self.present(avPlayerViewController, animated: true) { () -> Void in
            avPlayerViewController.player?.play()
        }
        
    }
    
 
    
    
    // MARK: WEBSERVICE IMPLEMNTAION
    
    
    func postVideoApi(){
    
        
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
       
        print(userID!)
        print("USERID AAGAYAI ")
        
        
        let token = temdict?.value(forKey: "token") as? String ?? ""

        let Passdict = ["hashtag": txtFeildHashTag.text!,
                        "category_name":"A",
                        "user_id":userID!,
                        "description":txtViewDescription.text!,
                        "token":token ] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requWithFilewith2Data(imageData: imagdata as NSData, videodata: videoData as NSData, fileName1: "image.jpg", fileName2: "video.mp4", imageparam1: "thumbnail", imageparam2: "video", urlString: "videos", parameters: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    print("SUCCESFILL POST VIDEO")
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
                
                    },failure: { (Error) in
                
                        Indicator.shared.hideProgressView()
                
                        _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                
                
                    })
            

        }else{
            
            Indicator.shared.hideProgressView()
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)


        }


        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}
