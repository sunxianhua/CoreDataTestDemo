//
//  ExtesionUI.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/29.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//


import Foundation
import UIKit

//设置颜色
func Set_Color(r: CGFloat,g: CGFloat,b: CGFloat ,alpha: CGFloat) -> UIColor {
    let color = UIColor(red: r/255.00, green: g/255.00, blue: b/255.00, alpha: alpha)
    return color
}


//扩展方法
extension UIButton{
    
    func set(image anImage: UIImage?, title: String,
             titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        
        
        //  self.setNeedsLayout()
        self.setNeedsDisplay()
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        
        let titleSize = title.size(withAttributes: [NSAttributedStringKey.font: titleFont!])
        
        
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
}

extension String{
    
    //动态计算字符串高度
    func getLabHeigh(font:UIFont,width:CGFloat) -> CGSize {
        
        let size = CGSize(width: width, height: 900)
        
        let strSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font :font], context:nil).size
        
        return strSize
        
    }
}

