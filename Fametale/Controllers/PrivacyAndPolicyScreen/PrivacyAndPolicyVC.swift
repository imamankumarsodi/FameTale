//
//  PrivacyAndPolicyVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class PrivacyAndPolicyVC: UIViewController {

    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtViewPrivacyPolicy: UITextView!
    
    //MARK:- VARIABLES
    //MARK:
    
    let WebserviceConnection  = AlmofireWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privayPolicyAPI()

        // Do any additional setup after loading the view.
    }

    
    func privayPolicyAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("privacypolicycontent", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    let responseDict = responseJson.dictionaryObject as? NSDictionary ?? [:]
                    
                    let dataDict = responseDict.value(forKey: "data") as? NSDictionary ?? [:]
                    
                    print(dataDict)
                    
                    self.txtViewPrivacyPolicy.text = dataDict.value(forKey: "description") as? String ?? ""
                    
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
        self.navigationController?.popViewController(animated: true)
    }

}
