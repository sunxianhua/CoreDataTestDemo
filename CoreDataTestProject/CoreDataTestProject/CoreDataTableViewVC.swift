//
//  CoreDataTableViewVC.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/27.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewVC: BaseViewController {
    
    var pathString = ""
    var personArray :[Person] = Array()
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creatViews()
        self.searchData()
        
        print(pathString)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private func creatViews(){
        
        self.view.addSubview(tableView)
        tableView.frame      = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 50.0)
        tableView.delegate   = self
        tableView.dataSource = self
        
        
        let addButton = UIButton.init(frame: CGRect.init(x: 50.0, y: tableView.frame.maxY, width: self.view.bounds.width - 100, height: 40))
        self.view.addSubview(addButton)
        addButton.setTitle("增加一项", for: .normal)
        addButton.backgroundColor = UIColor.black
        addButton.addTarget(self, action: #selector(self.addAction), for: .touchUpInside)
        
    }
    
    
    
    
    //增加一项
    @objc private func addAction(){
        
        
        self.showAlert(title: "请输入人名和性别标记", message: "人名/性别标记（1：男 2女）") { (inputSting) in
            self.add(text: inputSting)
            self.tableView.reloadData()
        }
        
        
    }
    
    
    fileprivate func showAlert(title :String?,message :String,blockAction :@escaping ((_ inputString :String?)->Void))
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (action :UIAlertAction!) in
            let textField = alert.textFields![0] as UITextField
            blockAction(textField.text)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField: UITextField) in
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    fileprivate func checkInput(inputString :String?) ->Bool{
        
        guard let theinputText = inputString else {
            print("未输入")
            return false
        }
        
        let textArray = theinputText.components(separatedBy: "/")
        if textArray.count < 2 {
            print("输入格式有误")
            self.showRemind(noticeString: "输入格式有误", callBlock: nil)
            return false
        }
        
        
        if let falge = Int64(textArray[1]) {
            
            
            if falge != 1 && falge != 2{
                print("输入性别格式有误,请输入 1 或者 2")
                self.showRemind(noticeString: "输入性别格式有误,请输入 1 或者 2", callBlock: nil)
                return false
            }
            
        }else{
            
            print("输入性别格式有误")
            self.showRemind(noticeString: "输入性别格式有误", callBlock: nil)
            return false
        }
        
        return true
    }
    
    
    //******************对数据库做操作*********
    //增加
    func add(text :String?){
        
        //检测输入格式是否正确
        if !self.checkInput(inputString: text){
            return
        }
        
        
        let textArray = text!.components(separatedBy: "/")
        //创建一个新的表实例，并赋值
        guard let thePerson = CoreDataManageTool<Person>().creatManagerObj(entityName: "Person")  else {
            return
        }
        thePerson.name    = textArray[0]
        thePerson.sexFlag = Int64(textArray[1])!
        
        if CoreDataManageTool().save() {
            self.personArray.append(thePerson)
            tableView.reloadData()
        }
        
    }
    
    
    
    func searchData(){
        
        let array = CoreDataManageTool<Person>().FetchRequest(fetchRequest: nil, entityName: "Person")
        
        self.personArray = array
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension CoreDataTableViewVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
        cell.textLabel?.text = "姓名：\(self.personArray[indexPath.row].name!) "
        
        let sexName = self.personArray[indexPath.row].sexFlag == 1 ? "男" : "女"
        cell.detailTextLabel?.text = "性别：\(sexName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.personArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击修改
        let model = self.personArray[indexPath.row]
        
        let remindString = model.sexFlag == 1 ? "\(model.name!)/男" : "\(model.name!)/女"
        self.showAlert(title: remindString, message: "请按格式修改 姓名/性别(1:男 2：女)") { (inputText) in
            
            
            if !self.checkInput(inputString: inputText) {
                return
            }
            
            
            let textArray = inputText!.components(separatedBy: "/")
            self.personArray[indexPath.row].name    = textArray[0]
            self.personArray[indexPath.row].sexFlag = Int64(textArray[1])!
            
            
            if CoreDataManageTool().save() {
                tableView.reloadData()
            }
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            //删除
            if CoreDataManageTool<Person>().delete(obj: personArray[indexPath.row]) {
                personArray.remove(at: indexPath.row)
                
                //刷新界面
                tableView.reloadData()
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
    
    
}


