//
//  Chat2VC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class Chat2VC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtMssgfield: UITextField!
    @IBOutlet weak var tblview_chat: UITableView!
    @IBOutlet weak var viewBottomChat: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    //MARK:- VARIABLE
    //MARK:
    let gradient = Gradient.singletonGradientObj
    var sender_name = ""
    var sender_id = ""
    let WebserviceConnection  = AlmofireWrapper()
    var dataArray = NSArray()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialSetup(){
        ScreeNNameClass.shareScreenInstance.screenName = "Chat2VC"
        ScreeNNameClass.shareScreenInstance.receiver_id = sender_id
        NotificationCenter.default.addObserver(self,selector:#selector(Chat2VC.reloadChatApi(_:)),name:NSNotification.Name(rawValue: "CHATNOTIFYRELOAD"),object: nil)

        lblHeader.text = sender_name
        print(sender_id)
        let viewBottomChatGradient = gradient.createBlueGreenGradient(from: viewBottomChat.bounds)
        self.viewBottomChat.layer.insertSublayer(viewBottomChatGradient, at: 0)
        viewBottomChat.layer.masksToBounds = true
        getMessagesService()
    }
    
    
    func scrollToBottom(){
        if dataArray.count > 0{
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
                self.tblview_chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
    }
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendMessageTapped(_ sender: Any) {
        
        if txtMssgfield.text == ""{
            
        }else{
           sendMessagesService()
        }
    }
    
    @objc func reloadChatApi(_ notification: Notification){
        getMessagesService()
    }
    func getMessagesService(){
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
            print(TemArray!)
            
            let temdict  =  TemArray?.object(at: 0) as? NSDictionary
            print(temdict!)
            
            let userID =  temdict?.value(forKey: "user_id") as? String ?? ""
            
            print(userID)
            print("USERID AAGAYAI ")
            
            
            let token = temdict?.value(forKey: "token") as? String ?? ""
            
            let Passdict = ["sender_id": self.sender_id,"token": token,"receiver_id":userID] as [String : Any]
            WebserviceConnection.requestPOSTURL("getmsg", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    let dummyArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    if dummyArray.count > 0{
                        
                        dummyArray.removeAllObjects()
                        self.dataArray = dummyArray
                        
                    }
                    print(responseJson)
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    self.dataArray = dataDict.value(forKey: "msg_thread") as? NSArray ?? []
                    print(self.dataArray)
                    self.tblview_chat.dataSource = self
                    self.tblview_chat.delegate = self
                    self.tblview_chat.reloadData()
                    self.scrollToBottom()
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("Failure")
                    
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
    
    func sendMessagesService(){
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
            print(TemArray!)
            
            let temdict  =  TemArray?.object(at: 0) as? NSDictionary
            print(temdict!)
            
            let userID =  temdict?.value(forKey: "user_id") as? String ?? ""
            
            print(userID)
            print("USERID AAGAYAI ")
            
            
            let token = temdict?.value(forKey: "token") as? String ?? ""
            
            let Passdict = ["sender_id": userID,"token": token,"receiver_id":self.sender_id,"msg":txtMssgfield.text!] as [String : Any]
            WebserviceConnection.requestPOSTURL("sendmessage", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    Indicator.shared.hideProgressView()
                    let dummyArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    if dummyArray.count > 0{
                        dummyArray.removeAllObjects()
                        self.dataArray = dummyArray
                    }
                    self.txtMssgfield.text = ""
                    print(responseJson)
                    self.getMessagesService()
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("Failure")
                    
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


/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension Chat2VC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblview_chat.register(UINib(nibName:"ChatSenderRecieverTableViewCell",bundle:nil), forCellReuseIdentifier: "ChatSenderRecieverTableViewCell")
        let cell = tblview_chat.dequeueReusableCell(withIdentifier: "ChatSenderRecieverTableViewCell", for: indexPath) as! ChatSenderRecieverTableViewCell
        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        if let flag =  dataDict.value(forKey: "flag") as? String{
            if flag == "1"{
                cell.viewBlue.isHidden = true
                cell.lblMessageBodyBlue.isHidden = true
                cell.lblTimeStampBlue.isHidden = true
                cell.viewGrey.isHidden = false
                cell.lblMessageBodyGray.isHidden = false
                cell.lblTimeStampGray.isHidden = false
                cell.lblMessageBodyGray.text = dataDict.value(forKey: "msg") as? String ?? ""
                cell.lblTimeStampGray.text = dataDict.value(forKey: "time") as? String ?? ""
                
            }else{
                cell.viewBlue.isHidden = false
                cell.lblMessageBodyBlue.isHidden = false
                cell.lblTimeStampBlue.isHidden = false
                cell.viewGrey.isHidden = true
                cell.lblMessageBodyGray.isHidden = true
                cell.lblTimeStampGray.isHidden = true
                cell.lblMessageBodyBlue.text = dataDict.value(forKey: "msg") as? String ?? ""
                cell.lblTimeStampBlue.text = dataDict.value(forKey: "time") as? String ?? ""
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat2VC") as! Chat2VC
//        vc.sender_name = dataDict.value(forKey: "name") as? String ?? ""
//        vc.sender_id = dataDict.value(forKey: "sender_id") as? String ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}

