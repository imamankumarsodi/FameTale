//
//  CategoryTableVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class CategoryTableVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblCategory: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    let tagNumber = 1
    var categoryArray = NSArray()
    
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
        self.tblCategory.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
        categoryAPI()
        
    }
    
    
    
    
    func categoryAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("topcateg", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    print("SUCCESS")
                    let wowVideoArray = responseJson["data"].arrayObject
                    //print(wowVideoArray)
                    self.categoryArray = wowVideoArray as? NSArray ?? [""]
                    print(self.categoryArray)
                    self.tblCategory.dataSource = self
                    self.tblCategory.delegate = self
                    self.tblCategory.reloadData()
                    
                    
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
extension CategoryTableVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchXibs = tblCategory.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
        
        
        if categoryArray.count != 0{
            
            
            let temDict =  categoryArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
            print(temDict)
            
            cell.lblTitle.text = temDict.value(forKey: "category_name") as? String ?? ""
            cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
        }
        else{
            print("Khali hai")
        }
    
        return cell
        
    }
    
    
}


