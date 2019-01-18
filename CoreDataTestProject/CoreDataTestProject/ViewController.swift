//
//  ViewController.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/22.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController {


    var cellStringArray = ["沙盒存储","CoreData存储"]
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creatViews()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private func creatViews(){
        
        self.view.addSubview(tableView)
        tableView.frame      = self.view.bounds
        tableView.delegate   = self
        tableView.dataSource = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
        cell.textLabel?.text = cellStringArray[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cellStringArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(self.view.subviews.count)
        
      //  self.showTextRemindView(noticeString: "测试文字", superView: nil)
        
     //   self.showWaitNotice(noticeString: "菊花圈等待电风扇的份上发送到发送到发送到环保部会不会被换班换班换班")
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(DocumentVC(), animated: true)
        case 1:
            self.navigationController?.pushViewController(CoreDataTableViewVC(), animated: true)
        default:
            print("")
        }
        
    }
    
}

















