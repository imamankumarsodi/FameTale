//
//  TagTableVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class TagTableVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tagTable: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    let tagNumber = 1
    var tagArray = NSArray()
    
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
        self.tagTable.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
      tagAPI()
        
    }
    
    func tagAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("toptags", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    print("SUCCESS")
                    let wowVideoArray = responseJson["data"].arrayObject
                    //print(wowVideoArray)
                    self.tagArray = wowVideoArray as? NSArray ?? [""]
                    print(self.tagArray)
                    self.tagTable.dataSource = self
                    self.tagTable.delegate = self
                    self.tagTable.reloadData()
                    
                    
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
extension TagTableVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tagArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchXibs = tagTable.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
        
        
        
        
        if tagArray.count != 0{
            
            
            let temDict =  tagArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
            print(temDict)
            
            cell.lblTitle.text = temDict.value(forKey: "tag_name") as? String ?? ""
            cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
        }
        else{
            print("Khali hai")
        }
        
        
        
        
        return cell
        
    }
    
    
}

