//
//  TopTableVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class TopTableVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var topTable: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    let tagNumber = 1
    var profilesArray = NSArray()
    
    let WebserviceConnection  = AlmofireWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        initialMethod()
    }
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        topProfileAPI()
        self.topTable.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
        
       
        
        
    }
    
    
    
    func topProfileAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("topprofile", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    print("SUCCESS")
                    let wowVideoArray = responseJson["data"].arrayObject
                    //print(wowVideoArray)
                    self.profilesArray = wowVideoArray as? NSArray ?? [""]
                    print(self.profilesArray)
                    self.topTable.dataSource = self
                    self.topTable.delegate = self
                    self.topTable.reloadData()
                    
                    
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
extension TopTableVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profilesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchXibs = topTable.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
        
        if profilesArray.count != 0{
            
            
            let temDict =  profilesArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
            print(temDict)
            
            cell.lblTitle.text = temDict.value(forKey: "name") as? String ?? ""
            cell.imgSearch.sd_setImage(with: URL(string: temDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            cell.imgSearch.layer.masksToBounds = false
            cell.imgSearch.clipsToBounds = true
            cell.lblSubTitle.text = temDict.value(forKey: "username") as? String ?? ""
        }
        else{
            print("Khali hai")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtherProfileVC") as? OtherProfileVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

