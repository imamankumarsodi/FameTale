//
//  CommentsVC.swift
//  Fametale
//
//  Created by Callsoft on 09/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import SDWebImage

class CommentsVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtFieldComment: UITextField!
    @IBOutlet weak var viewBottomComment: UIView!
    @IBOutlet weak var tblComments: UITableView!
    
    //MARK:- VARIABLE
    //MARK:
    let gradient = Gradient.singletonGradientObj
    var videoId = ""
    let WebserviceConnection  = AlmofireWrapper()
    var commnetArray = NSArray()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialSetup(){
        userCommentsShowAPI()
        let viewBottomCommentGradient = gradient.createBlueGreenGradient(from: viewBottomComment.bounds)
        self.viewBottomComment.layer.insertSublayer(viewBottomCommentGradient, at: 0)
        viewBottomComment.layer.masksToBounds = true

    }
    
    
    
    //MARK:- WEB SERVICES METHODS
    //MARK:
    
    func postCommentsOnVideoAPI(){
    
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        let token = temdict?.value(forKey: "token") as? String ?? ""
                let Passdict = ["video_id": videoId,
                        "message":txtFieldComment.text!,
                        "user_id":userID!,
                        "token":token] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("commentOnVideo", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    
                    let commentTempArray =  responseJson["data"].array
                    self.commnetArray = commentTempArray as? NSArray ?? [""]
                    self.txtFieldComment.text = ""
                    
                    
                    let message  = responseJson["message"].stringValue
                    
                   //_ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.success)
                    
                    let vc  =  self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    vc.isComingfromComment =  true
                    
                   
                    self.dismiss(animated: true, completion: nil)
                   
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
            },failure: { (Error) in
                
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    func userCommentsShowAPI(){
   
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("commentlist/\(videoId)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    print("WOW SUCCESS")
                    
                    let commentTempArray = responseJson["data"].arrayObject
                    //print(wowVideoArray)
                    self.commnetArray = commentTempArray as? NSArray ?? [""]
                    
                    self.tblComments.dataSource = self
                    self.tblComments.delegate = self
                    self.tblComments.reloadData()
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
                }
                
                
            },failure: { (Error) in
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
         postCommentsOnVideoAPI()
    }
}
//MARK:- EXTENTION OF CLASS
//MARK:
extension CommentsVC:UITableViewDelegate,UITableViewDataSource{
    
    
    //TODO:-TABLEVIEW DELEGATES
    //TODO:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnCount = Int()
        
        returnCount = commnetArray.count
        
        return returnCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tblComments.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
          let tempDict  = commnetArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        let myMutableString1 = NSMutableAttributedString()
        
        let myMutableString2 = NSAttributedString(string: "\(tempDict.value(forKey: "username") as? String ?? "") ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 15.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString3 = NSAttributedString(string: "\(tempDict.value(forKey: "message") as? String ?? "") ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor.darkGray])
        let myMutableString4 = NSAttributedString(string: "\(tempDict.value(forKey: "created_at") as? String ?? "") ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 11.0)!, .foregroundColor :UIColor.darkGray])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)
        cell.imgComments.sd_setImage(with: URL(string: tempDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
        cell.imgComments.layer.masksToBounds = false
        cell.imgComments.clipsToBounds = true
        
      
        cell.lblComments.attributedText = myMutableString1
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

