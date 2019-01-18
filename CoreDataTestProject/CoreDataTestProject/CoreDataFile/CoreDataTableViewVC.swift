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
    
    lazy var bookCoreDataTool :CoreDataTool<Book> = {
        let tool = CoreDataTool<Book>.init(modelName: "Book")
        return tool
    }()
    
    
    var pathString = ""
    
    var bookArray :[Book] = Array()
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
        
        if let bookModel = self.bookCoreDataTool.creatEntityModel(entityName: "Book") {
            bookModel.name = "书名\(self.bookArray.count+1)"
            bookModel.price = 100.00
            if self.bookCoreDataTool.saveContext() {
                
                self.bookArray.append(bookModel)
                debugPrint("存储成功")
            }
            
        }
        
        
        self.tableView.reloadData()
        
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
        
        
        
        
    }
    
    
    
    func searchData(){
        
        let _ = self.bookCoreDataTool
        let books = self.bookCoreDataTool.FetchRequest(fetchRequest: nil, entityName: "Book")
        self.bookArray = books
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension CoreDataTableViewVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
       let cellModel = self.bookArray[indexPath.row]
        cell.textLabel?.text = cellModel.name
        cell.detailTextLabel?.text = "\(cellModel.price)元";
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.bookArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击修改
        let model = self.bookArray[indexPath.row]
        model.name = "修改了"
         _ = self.bookCoreDataTool.saveContext()
        
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            //删除
            bookCoreDataTool.delete(obj: self.bookArray[indexPath.row])
            self.bookArray.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
    
    
}


