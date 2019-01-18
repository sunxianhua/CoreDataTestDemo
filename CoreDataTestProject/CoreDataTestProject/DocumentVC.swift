//
//  DocumentVC.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/28.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//

import Foundation
import UIKit

class DocumentVC:  BaseViewController{
    
    var Width :CGFloat = 0
    var Height :CGFloat = 0
    
    var textView = UITextView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Width = self.view.bounds.width
        Height = self.view.bounds.height
        
        self.creatViews()
        self.getSaveValue()
        
    }
    
    private func creatViews(){
        
        self.view.backgroundColor = UIColor.white
        
        textView.frame = CGRect.init(x: 30, y: 80, width: Width - 60, height: 200)
        self.view.addSubview(textView)
        
        textView.layer.cornerRadius  = 5.0
        textView.layer.borderColor   = UIColor.lightGray.cgColor
        textView.layer.borderWidth   = 1.0
        textView.layer.masksToBounds = true
        textView.backgroundColor     = UIColor.white
        
        
        let addButton = UIButton.init(frame: CGRect.init(x: 50.0, y: Height - 60.0, width: self.view.bounds.width - 100, height: 40))
        self.view.addSubview(addButton)
        addButton.setTitle("保存", for: .normal)
        addButton.backgroundColor = UIColor.black
        addButton.addTarget(self, action: #selector(self.saveAction), for: .touchUpInside)
        
    }
    
    
    private func getSaveValue(){
        
        guard let path = PersistenceTool().getObgectWithKey(key: "PATH") as? String else {
            return
        }
        
        self.textView.text = PersistenceTool.getStringFromePath(savePath: path)
        
    }
    
    
    @objc private func saveAction(){
        
        let alertVC = UIAlertController.init(title: "存储输入值", message: "选择存储路径类型", preferredStyle: .actionSheet)
        let typeArray :[DocumentsPathType] = [.documents_Type,.Caches_Type,.Preference_Type,.temp_Type]
        
        
        //确定存储路径
        var pathString = ""
        for item in typeArray {
            
            let saveAction = UIAlertAction(title: item.rawValue, style: .default) { (action :UIAlertAction!) in
                
                pathString = PersistenceTool.getRelativePath(pathType: item) + "/theText.text"
                self.saveValues(pathString: pathString)
            }
            alertVC.addAction(saveAction)
        }
        self.present(alertVC, animated: true, completion: nil)
        
        
        
    }
    
    
    //将输入文本值存入指定路径，并将路径存储
    private func saveValues(pathString :String){
        
        if !PersistenceTool.saveStringToPath(savePath: pathString, saveString: textView.text) {
            
            self.showRemind(noticeString: "存储失败", callBlock: nil)
            debugPrint("存储失败")
        }
        
        
        self.showRemind(noticeString: "成功") {
            //把路径存起来
            PersistenceTool.savePrefWithKey(key: "PATH", object: pathString)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
        
    }
    
}
