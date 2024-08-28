//
//  ChatVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblview_chatList: UITableView!
    
    
    
    //MARK:- VARIABLE
    //MARK:
    let WebserviceConnection  = AlmofireWrapper()
    var dataArray = NSArray()
    var isComing = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        tblview_chatList.tableFooterView = UIView()
        ScreeNNameClass.shareScreenInstance.screenName = "ChatVC"
        NotificationCenter.default.addObserver(self,selector:#selector(ChatVC.reloadChatListApi(_:)),name:NSNotification.Name(rawValue: "CHATLISTNOTIFYRELOAD"),object: nil)
       chatListService()
    }

    func chatListService(){
        
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
            
            let Passdict = ["user_id": userID,"token": token] as [String : Any]
           WebserviceConnection.requestPOSTURL("chatpage", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    print(self.dataArray)
                    self.tblview_chatList.dataSource = self
                    self.tblview_chatList.delegate = self
                    self.tblview_chatList.reloadData()
                    
                    
                    
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
    
    //MARK:- ACTIONS
    //MARK:
    @IBAction func btnNavigationTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func btnNewChatTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewMessageVC") as? NewMessageVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func reloadChatListApi(_ notification: Notification){
        chatListService()
    }
}

/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension ChatVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblview_chatList.register(UINib(nibName:"ChatListTableViewCell",bundle:nil), forCellReuseIdentifier: "ChatListTableViewCell")
        let cell = tblview_chatList.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        cell.lblName.text = dataDict.value(forKey: "name") as? String ?? ""
        cell.lblMessageBody.text = dataDict.value(forKey: "msg") as? String ?? ""
        cell.lblTimeStamp.text = dataDict.value(forKey: "fftime") as? String ?? ""
        cell.imgProfileView.sd_setImage(with: URL(string: dataDict.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
       
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat2VC") as! Chat2VC
        vc.sender_name = dataDict.value(forKey: "name") as? String ?? ""
        vc.sender_id = dataDict.value(forKey: "sender_id") as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



