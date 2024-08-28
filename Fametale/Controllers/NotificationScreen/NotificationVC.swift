//
//  NotificationVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var tblNotification: UITableView!
    
    //MARK:- VARIABLE
    //MARK:
    
    var dataArray = NSArray()
   let WebserviceConnection  = AlmofireWrapper()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //initialMethod()
        tabBarController?.tabBar.isHidden =  false
        notificationListing()
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialSetup(){
        
        
        ScreeNNameClass.shareScreenInstance.screenName = "NotificationVC"
        NotificationCenter.default.addObserver(self,selector:#selector(NotificationVC.reloadNotificationApi(_:)),name:NSNotification.Name(rawValue: "NOTIFICARIONNOTIFYRELOAD"),object: nil)
        
       notificationListing()
    }
    
    //MARK:- ACTIONS
    //MARK:
    @IBAction func btnSearchTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchTopVC") as? SearchTopVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    @IBAction func btnChatTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func reloadNotificationApi(_ notification: Notification){
        notificationListing()
    }
    func notificationListing(){
        
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        
        
        let temdict  =  temArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            //            self.viewWow.backgroundColor = .white
            //            self.viewVideos.backgroundColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            
            WebserviceConnection.requestGETURL("notifylist/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {

                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    if self.dataArray.count > 0{
                        let dummyArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                        dummyArray.removeAllObjects()
                        self.dataArray = dummyArray
                    }
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    print(self.dataArray)
                    
                    self.tblNotification.delegate = self
                    self.tblNotification.dataSource = self
                    self.tblNotification.reloadData()
            
                    
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
    
    
    
    
}
//MARK:- EXTENTION OF CLASS
//MARK:
extension NotificationVC:UITableViewDelegate,UITableViewDataSource{
    
    
    //TODO:-TABLEVIEW DELEGATES
    //TODO:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return dataArray.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        cell.imgNotification.sd_setImage(with: URL(string: dataDict.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
        
         let boldText = dataDict.value(forKey: "name") as? String ?? ""
         let normalText  = " \(dataDict.value(forKey: "msg") as? String ?? "")"
         let dateText = " \(dataDict.value(forKey: "time") as? String ?? "")"
        
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "\(boldText) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 13.0)!, .foregroundColor :UIColor.black])
    
        let myMutableString3 = NSAttributedString(string: "\(normalText) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        
        let myMutableString4 = NSAttributedString(string: "\(dateText) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Bold, size: 11.0)!, .foregroundColor :UIColor.darkGray])
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)

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

