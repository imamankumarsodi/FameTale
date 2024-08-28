//
//  TestViewController.swift
//  Fametale
//
//  Created by abc on 18/09/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import Lottie


class TestViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var view_Header: UIView!
    
    // MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        addLiveGradient()

        // Do any additional setup after loading the view.
    }


    
    // MARK: - Methods
    
    func addLiveGradient(){
        
        
        
        let animationView = LOTAnimationView(name: "animation-w1080-h1920")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view_Header.frame.width, height: self.view_Header.frame.height)
        
        animationView.center = self.view_Header.center
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.8
        animationView.loopAnimation = true
        animationView.clipsToBounds = true
        view_Header.addSubview(animationView)
        animationView.play()

    }

}
