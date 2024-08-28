//
//  TabBarVC.swift
//  Tapitt
//
//  Created by Dacall soft on 25/10/17.
//  Copyright © 2017 Dacall soft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController
{
    
    @IBOutlet weak var tabBarBottom: UITabBar!
    
    var secondItemImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        setTabBarSelectedImage()
        
        UITabBar.appearance().barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(red: 75/255, green: 135/255, blue: 161/255, alpha: 1.0)
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }

        let secondItemView = self.tabBar.subviews[2]
        self.secondItemImageView = secondItemView.subviews.first as! UIImageView
        self.secondItemImageView.contentMode = .center
    }
   

    override func viewWillLayoutSubviews()
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var kBarHeight:CGFloat
        if screenHeight == 812{
            kBarHeight = 94
        }else{
            kBarHeight = 64
            
        }
        var tabFrame: CGRect = tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = view.frame.size.height - kBarHeight
        tabBar.frame = tabFrame
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setTabBarSelectedImage()
    {
        
        let arrImageNormal : NSArray = ["home_un","trending_un","camera_un","notification_un","more_un"]
        let arrImageSelected : NSArray = ["home_s","trending_s","camera_s","notification_s","more_s"]
        
        for (index, _) in (self.tabBar.items?.enumerated())!
        {
            let tabItem2  = self.tabBar.items![index]
            tabItem2.selectedImage = UIImage(named:arrImageSelected.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)
            tabItem2.image=UIImage(named:arrImageNormal.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)
          //  tabItem2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {
        print("gedjioj ")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
//        if toShowList
//        {
////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingVC") as! ListingVC
////
////            vc.isFromHomeList = "true"
////
////
////            UIView.animate(withDuration: 0.75, animations: { () -> Void in
////                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
////
////
////                self.navigationController!.pushViewController(vc, animated: false)
////
////                UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
////            })
//        }
        
    }
}
