//
//  MyContactsVC.swift
//  Fametale
//
//  Created by Callsoft on 12/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class MyContactsVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblContacts: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    var contacArray = [Any]()

    let gradient = Gradient.singletonGradientObj
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        self.tblContacts.register(UINib(nibName:"ShareXib",bundle:nil), forCellReuseIdentifier: "ShareXib")
        
        tblContacts.dataSource = self
        tblContacts.delegate = self
        tblContacts.reloadData()
        
        
    }
    
    @objc func buttonSendTapped(_ sender: AnyObject) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "RequestSentVC") as! RequestSentVC
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- EXTENSION OF CLASS
//MARK:
extension MyContactsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ShareXib = tblContacts.dequeueReusableCell(withIdentifier: "ShareXib", for: indexPath) as! ShareXib
        
        
        
        if contacArray.count != 0{
            
            
            let dataDict = contacArray[indexPath.row] as? NSDictionary ?? [:]
            
            let flag = dataDict.value(forKey: "flag") as? String ?? ""
            if flag == "1"{
                cell.btnSend.isHidden = false
                let sendButtonGradient = self.gradient.createBlueGreenGradient(from: cell.btnSend.bounds)
                cell.btnSend.layer.insertSublayer(sendButtonGradient, at: 0)
                cell.btnSend.layer.cornerRadius = 14
                cell.btnSend.layer.masksToBounds = true
                cell.btnSend.addTarget(self, action:#selector(buttonSendTapped(_:)), for:.touchUpInside)
            }
            else{
                cell.btnSend.isHidden = true
            }
            cell.imgShare.sd_setImage(with: URL(string: dataDict.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            let phone = dataDict.value(forKey: "phone") as? String ?? ""
            let name = dataDict.value(forKey: "name") as? String ?? ""
            cell.lblSubTitle.text = "\(name)\n\(phone)"
           
    
        }
        else{
            print("Khali hai")
        }
        

        return cell
        
    }
}

