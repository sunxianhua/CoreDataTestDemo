//
//  BaseViewController.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/28.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//  基控件

import Foundation
import UIKit
class BaseViewController:  UIViewController{
    
    
    lazy var remindLabel :UILabel = {
        
        let label = UILabel()
        label.layer.cornerRadius = 2.0
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.lightGray
        label.isHidden = true
        label.frame  = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        label.center = UIApplication.shared.keyWindow!.center
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showRemind(noticeString :String,callBlock :(()->Void)?){
        
        self.view.addSubview(remindLabel)
        self.remindLabel.isHidden = false
        self.remindLabel.text = noticeString
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            //执行回调
            
            self.remindLabel.isHidden = true
            self.remindLabel.text = ""
            
            guard let block = callBlock else {
                return
            }
            block()
            
        }
    
        
    }
}
