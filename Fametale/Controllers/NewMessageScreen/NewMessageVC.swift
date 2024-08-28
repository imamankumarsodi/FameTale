//
//  NewMessageVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class NewMessageVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblNewMessage: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var search: UISearchBar!
    //MARK:- VARIABLES
    //MARK:
    let tagNumber = 1
    let WebserviceConnection  = AlmofireWrapper()
    var dataArray = NSArray()
    //******* SearchBar
    var searchActive = false
    var filtered : NSMutableArray = NSMutableArray()
    
    //****** For Showing follower and following list
    var isComing = String()
    var userID = String()
    var serviceName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        search.delegate = self
        if isComing == "FOLLOWER"{
           lblHeader.text = "Followers"
        }else if isComing == "FOLLOWING"{
            lblHeader.text = "Followings"
        }
        else{
            lblHeader.text = "New Messages"
            
        }
        followersList()
    }
    
    
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func followersList(){
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            if isComing == "FOLLOWER"{
                serviceName = "followersList"
            }else if isComing == "FOLLOWING"{
                serviceName = "followingList"
            }
            else{
                let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
                print(TemArray!)
                let temdict  =  TemArray?.object(at: 0) as? NSDictionary
                print(temdict!)
                userID =  temdict?.value(forKey: "user_id") as? String ?? ""
                print(userID)
                serviceName = "followersList"
            }
            Indicator.shared.showProgressView(self.view)
            WebserviceConnection.requestGETURL("\(serviceName)/\(userID)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    let dummyArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    if dummyArray.count > 0{
                        
                        dummyArray.removeAllObjects()
                        self.dataArray = dummyArray
                        
                    }

                    print(responseJson)
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    print(self.dataArray)
                    self.tblNewMessage.dataSource = self
                    self.tblNewMessage.delegate = self
                    self.tblNewMessage.reloadData()
                    
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

//MARK:- EXTENSION OF CLASS
//MARK:
extension NewMessageVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if searchActive == true {
            
            return filtered.count
        }
            
        else {
            return self.dataArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchActive == true{
            self.tblNewMessage.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
            let cell : SearchXibs = tblNewMessage.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
            let dataDict = filtered.object(at: indexPath.row) as? NSDictionary ?? [:]
            cell.lblTitle.text = dataDict.value(forKey: "name") as? String ?? ""
            cell.imgSearch.sd_setImage(with: URL(string: dataDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            cell.lblSubTitle.text = dataDict.value(forKey: "username") as? String ?? ""
            return cell
        }else{
    
        self.tblNewMessage.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
        let cell : SearchXibs = tblNewMessage.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
        let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
        cell.lblTitle.text = dataDict.value(forKey: "name") as? String ?? ""
        cell.imgSearch.sd_setImage(with: URL(string: dataDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
        cell.lblSubTitle.text = dataDict.value(forKey: "username") as? String ?? ""
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive == true{
            if isComing == "FOLLOWER"{
                let dataDict = filtered.object(at: indexPath.row) as? NSDictionary ?? [:]
                let otherUserID = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
                print(temArray!)
                
                let temdict  =  temArray?.object(at: 0) as? NSDictionary
                print(temdict!)
                
                let userID =  temdict?.value(forKey: "user_id") as? String
                if userID != otherUserID{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                    vc.userID = otherUserID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }else if isComing == "FOLLOWING"{
                let dataDict = filtered.object(at: indexPath.row) as? NSDictionary ?? [:]
                let otherUserID = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
                print(temArray!)
                
                let temdict  =  temArray?.object(at: 0) as? NSDictionary
                print(temdict!)
                
                let userID =  temdict?.value(forKey: "user_id") as? String
                if userID != otherUserID{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                    vc.userID = otherUserID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else{
                let dataDict = filtered.object(at: indexPath.row) as? NSDictionary ?? [:]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat2VC") as! Chat2VC
                vc.sender_name = dataDict.value(forKey: "name") as? String ?? ""
                vc.sender_id = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            if isComing == "FOLLOWER"{
               let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                let otherUserID = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
                print(temArray!)
                
                let temdict  =  temArray?.object(at: 0) as? NSDictionary
                print(temdict!)
                
                let userID =  temdict?.value(forKey: "user_id") as? String
                if userID != otherUserID{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                    vc.userID = otherUserID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }else if isComing == "FOLLOWING"{
                let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                let otherUserID = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
                print(temArray!)
                
                let temdict  =  temArray?.object(at: 0) as? NSDictionary
                print(temdict!)
                
                let userID =  temdict?.value(forKey: "user_id") as? String
                if userID != otherUserID{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                    vc.userID = otherUserID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else{
                let dataDict = dataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Chat2VC") as! Chat2VC
                vc.sender_name = dataDict.value(forKey: "name") as? String ?? ""
                vc.sender_id = String(dataDict.value(forKey: "user_id") as? Int ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        
        }
    }
    
}



// MARK: SEARCH BAR DELEGATE METHODS

extension NewMessageVC:UISearchBarDelegate{

    // When button "Search" pressed on search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.search.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            searchActive = false
        }
            
        else {
            searchActive = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("THE ENTER TEXT", searchText)
        filtered.removeAllObjects()
        
        if searchBar.text!.isEmpty {
            searchActive = false
        }
            
        else {
            
            searchActive = true
            
            if dataArray.count >= 1 {
                
                for index in 0...dataArray.count - 1 {
                    
                    let dicResponse = dataArray.object(at: index) as? NSDictionary ?? [:]
                    
                    let documentName = dicResponse.object(forKey: "name") as? String ?? ""
                    
                    if (documentName.lowercased().range(of: searchText.lowercased()) != nil) {
                        
                        filtered.add(dicResponse)
                    }
                }
            }
        }
        
        tblNewMessage.reloadData()
    }
    
}
