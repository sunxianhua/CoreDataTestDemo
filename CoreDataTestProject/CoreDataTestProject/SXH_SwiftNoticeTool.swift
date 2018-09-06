//
//  SXH_SwiftNoticeTool.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/28.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//  用于做提示的工具类

import Foundation
import UIKit



//扩展
extension UIResponder {
    
    //只显示提示语 并且在 1.5秒后自动消失
    func showTextRemindView(noticeString :String,superView :UIView?){
        
        _ = SXH_SwiftNoticeTool().showNoticeImage(imageName: "", noticeString: noticeString, superView: superView, autoClear: true, autoClearTime: 1.5, callBlock: nil)
        
    }
    
    
    //显示提示界面，不自动消失，有点击回调(点击后当前提示语消失)
    func showTextRemindView(imageName :String?,noticeString :String?,superView :UIView?,clickBlock :(()->Void)?){
        
        //出现提示界面
        let noticeTool = SXH_SwiftNoticeTool()
        noticeTool.showNoticeImage(imageName: imageName, noticeString: noticeString, superView: superView, autoClear: false, autoClearTime: nil, callBlock: nil).clickCallback {
            
            
            //点击回调
            SXH_SwiftNoticeTool.clearView(superView: superView)
            guard let block = clickBlock else {
                return
            }
            block()
            
        }
        
    }
    
    
    
    //显示网络请求等待菊花圈
    func showWaitNotice(noticeString :String,superView :UIView?,clickBlock :(()->Void)?){
        
        SXH_SwiftNoticeTool.showWaitNoticeView(noticeString: noticeString, superView: superView).clickCallback {
            
            //点击回调
            SXH_SwiftNoticeTool.clearView(superView: superView)
            guard let block = clickBlock else {
                return
            }
            block()
        }
        
        
    }
    
    
    
}



class SXH_SwiftNoticeTool: NSObject {
    
    static var theWindows :[UIView] = Array()
    static var falgeTag :Int = 1000
    static var theAutoClear :Bool = true
    
    /*
     imageName :提示语图片名
     noticeString :提示语
     superView  :提示控件父视图
     autoClear  :是否自动消失
     autoClearTime :显示时长
     callBlock  : 显示完后的回调
     
     */
    func showNoticeImage(imageName :String?,noticeString :String?,superView :UIView?,autoClear :Bool,autoClearTime :Double?,callBlock :(()->Void)?) ->RemindView{
        
        
        //有父视图 superView  则直接在父视图上添加
        let remindView :RemindView!
        if let view = superView {
            remindView = RemindView.init(remindImageName: imageName, remindString: noticeString, titlePosition: nil, frame: view.bounds)
            remindView.tag = SXH_SwiftNoticeTool.falgeTag
            
            superView!.addSubview(remindView)
        }else{
            
            //没有则新建一个最上层窗口，添加提示控件
            let window             = UIWindow.init(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.clear
            window.windowLevel     = UIWindowLevelAlert
            window.isHidden        = false
    
            remindView = RemindView.init(remindImageName: imageName, remindString: noticeString, titlePosition: nil, frame: UIScreen.main.bounds)
            
            window.addSubview(remindView)
    
            SXH_SwiftNoticeTool.theWindows.append(window)
        }
        
        
        //消失并返回
        if !autoClear {
            return remindView
        }

        let time = autoClearTime == nil ? 1.0 : autoClearTime!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {

            SXH_SwiftNoticeTool.clearView(superView: superView)
        }
        
        
        return remindView
    }
    
    
    
    class func showWaitNoticeView(noticeString :String,superView :UIView?) ->RemindView{
        
        let activityview = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50.0, height: 50.0))
        activityview.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityview.startAnimating()
        
        let backView :UIView!
        if let view = superView {
            backView = view
            
        }else{
            
            //没有则新建一个最上层窗口，添加提示控件
            let window             = UIWindow.init(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.clear
            window.windowLevel     = UIWindowLevelAlert
            window.isHidden        = false
            
            SXH_SwiftNoticeTool.theWindows.append(window)
            backView = window

        }
        
        backView.tag = SXH_SwiftNoticeTool.falgeTag
        

        let remindView = RemindView.init(waitNotice: noticeString, frame: backView.bounds)
        backView.addSubview(remindView)
        
        return remindView
        
    }
    
    
    
    //清除提示界面
    class func clearView(superView :UIView?){
    
        if let view = superView {
            
            let array = view.subviews
            guard let index = (array.index { (item) -> Bool in
                return item.tag == SXH_SwiftNoticeTool.falgeTag
            }) else {
                return
            }
            array[index].isHidden = true
            array[index].removeFromSuperview()
            
            
        }else{
        
            for item in SXH_SwiftNoticeTool.theWindows {
                
                item.isHidden = true
                item.removeFromSuperview()
            }
            
        }
        
    }
    
    
    
}




class RemindView: UIView {
    
    
    let width  :CGFloat = 100.0
    let height :CGFloat = 100.0
    
    /// 定义回调
    typealias CallbackValue=()->Void
    /// 声明闭包
    var chooesCallbackValue:CallbackValue?
    //回调方法
    func clickCallback(value:CallbackValue?){
        chooesCallbackValue = value //返回值
    }
    

    
    
    var remindButton = UIButton()
    
    
    //带菊花圈的初始化方式
    convenience init(waitNotice :String,frame :CGRect){
        
        self.init(remindImageName: "", remindString: waitNotice, titlePosition: nil, frame: frame)
        self.creatWaitView(noticeString: waitNotice)
    }
    
    
    //带图片和文件的初始化方式
    init(remindImageName :String?,remindString:String?,titlePosition :UIViewContentMode?,frame :CGRect){
        super.init(frame: frame)
        self.creatViews(remindImageName: remindImageName, remindString: remindString, titlePosition: titlePosition)
    }
    
    
    //创建带菊花圈的视图
    func creatWaitView(noticeString :String){
        
        let activityview = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 40.0, height: 40.0))
        activityview.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityview.startAnimating()
        
        self.remindButton.addSubview(activityview)
        
        activityview.center = CGPoint.init(x: remindButton.frame.width/2.0, y: (remindButton.frame.height/2.0 - 15.0))
      //  activityview.center = self.remindButton.center
        
    }
    
    
    //创建图片和文字的提示框
    func creatViews(remindImageName :String?,remindString:String?,titlePosition :UIViewContentMode?){
        
        
        self.tag = SXH_SwiftNoticeTool.falgeTag //做标记（方便删除）

        self.backgroundColor     = Set_Color(r: 100, g: 100, b: 100, alpha: 0.6)
        
        self.remindButton.backgroundColor = UIColor.darkGray
        self.addSubview(remindButton)
        self.remindButton.layer.cornerRadius  = 5.0
        self.remindButton.layer.masksToBounds = true
        
        
        self.addSubview(remindButton)
        
        
        var theTitle = ""
         let position = titlePosition == nil ? UIViewContentMode.bottom : titlePosition!
        
        
        if let title = remindString {
            theTitle = title
        }
        
        if let imageName = remindImageName {
            
            remindButton.set(image: UIImage.init(named: imageName), title: theTitle, titlePosition: position, additionalSpacing: 5.0, state: .normal)
        }else{
            remindButton.setTitle(theTitle, for: .normal)
        }
        self.remindButton.setTitleColor(UIColor.white, for: .normal)
        
        
       
        remindButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        remindButton.titleLabel?.numberOfLines = 0
    
        //点击
        self.remindButton.addTarget(self, action: #selector(self.clickAction), for: .touchUpInside)
        
        
        //布局
        var remindSize :CGSize = CGSize.init(width: width, height: 40.0)
        remindSize.height      = remindImageName == nil ? 40.0 : self.height

        
        if let title = remindString {
            theTitle = title
            
            if position == UIViewContentMode.bottom || position == UIViewContentMode.top {
                remindSize.width = CGFloat(theTitle.count) * 18.0 <= width ? width : CGFloat(theTitle.count) * 18.0
                
            }else{
                remindSize.width = CGFloat(theTitle.count) * 18.0 + remindSize.width
            }
            
            
        }
        
        
        //判断是否超过父视图
        remindSize.width = remindSize.width <= super.bounds.size.width ? remindSize.width : super.bounds.size.width
        remindSize.height = remindSize.height <= super.bounds.size.height ? remindSize.height : super.bounds.size.height
        
        self.remindButton.frame  = CGRect.init(x: 0, y: 0, width: remindSize.width, height: remindSize.height)
        self.remindButton.center = CGPoint.init(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        
    }
    
    
    
    
    
    @objc private func clickAction(){
        
        guard let block = chooesCallbackValue else {
            return
        }
        
        block()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}










