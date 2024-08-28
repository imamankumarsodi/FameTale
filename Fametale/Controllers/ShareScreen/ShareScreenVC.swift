//
//  ShareScreenVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class ShareScreenVC: UIViewController {
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblShare: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    let nameArray = ["Wade Wilson","Nicolas cage","Kate upton","Chris Pratt"]
    let imageArray = ["img_a_notification","img_b_notification","img_c_notification","img_d_notification"]
    let idArray = ["@deadpool","@ghostrider","@bugsbunny","@starlord"]
    let gradient = Gradient.singletonGradientObj
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        self.tblShare.register(UINib(nibName:"ShareXib",bundle:nil), forCellReuseIdentifier: "ShareXib")
        
        tblShare.dataSource = self
        tblShare.delegate = self
        tblShare.reloadData()
        
        
    }
    @objc func buttonSendPressed(_ sender: AnyObject) {
 self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
}

//MARK:- EXTENSION OF CLASS
//MARK:
extension ShareScreenVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ShareXib = tblShare.dequeueReusableCell(withIdentifier: "ShareXib", for: indexPath) as! ShareXib
        cell.lblTitle.text = nameArray[indexPath.row]
        cell.imgShare.image = UIImage(named: imageArray[indexPath.row])
        cell.lblSubTitle.text = idArray[indexPath.row]
        let sendButtonGradient = self.gradient.createBlueGreenGradient(from: cell.btnSend.bounds)
        cell.btnSend.layer.insertSublayer(sendButtonGradient, at: 0)
        cell.btnSend.layer.cornerRadius = 14
        cell.btnSend.layer.masksToBounds = true
        cell.btnSend.addTarget(self, action:#selector(buttonSendPressed(_:)), for:.touchUpInside)
        return cell
        
    }
}
