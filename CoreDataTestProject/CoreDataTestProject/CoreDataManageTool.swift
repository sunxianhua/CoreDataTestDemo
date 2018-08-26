//
//  CoreDataManageTool.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/24.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//


import Foundation
import UIKit
import CoreData

let managerAppDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObectContext = managerAppDelegate.persistentContainer.viewContext

public let Width = UIScreen.main.bounds.size.width
public let Height = UIScreen.main.bounds.size.height
public var MainBounds = UIScreen.main.bounds


class CoreDataManageTool<N :NSManagedObject>: NSObject {
    
    //******************对数据库做操作*********
    /*
     
     查询操作必须会用到的一个类 NSFetchRequest
     NSFetchRequest是CoreDate 中用于查询表的一个类，可设置各种其各种参数查找对应数据
     
     
     //NSFetchRequest  对应属性
     fetchLimit：结果集最大数，相当于 SQL 中的limit
     fetchOffset：查询的偏移量，默认为0
     fetchBatchSize：分批处理查询的大小，查询分批返回结果集
     entityName/entity：数据表名，相当于 SQL中的from
     propertiesToGroupBy：分组规则，相当于 SQL 中的group by
     propertiesToFetch：定义要查询的字段，默认查询全部字段
     
     
     NSFetchRequest  中有两个 可配合使用的 实例属性
     predicate：是NSPredicate对象 -- 相当于谓词的作用
     sortDescriptors：它是一个NSSortDescriptor数组，数组中前面的优先级比后面高。可以有多个排列规则
     
     
     */
    
    
    //获得查询请求 entityName --> 表名
    func getFetchRequest(entityName :String) ->NSFetchRequest<NSFetchRequestResult>{
        let theFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return theFetchRequest
    }
    
    
    //创建一个obj
    func creatManagerObj(entityName :String) ->N?{
        
        let theObj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObectContext) as? N
        return theObj
    }
    
    
    //保存
    func save() ->Bool{
    
        do{
            try managedObectContext.save()
            return true
        }catch{
            fatalError("增加失败")
        }
        
        return false
    }
    
    
    //删
    func delete(obj :NSManagedObject) ->Bool{
        
        managedObectContext.delete(obj)
        return self.save()
    }
    
    //查
    func FetchRequest(fetchRequest :NSFetchRequest<NSFetchRequestResult>?,entityName :String) ->[N]{
        
        let theFetchRequest :NSFetchRequest<NSFetchRequestResult>!
        
        if fetchRequest == nil {
            theFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        }else{
            theFetchRequest = fetchRequest!
        }
        
        
        //开始查找
        do{
            let resultArray = try managedObectContext.fetch(theFetchRequest) as! [N]
            return resultArray
        }catch {
            fatalError("查找\(entityName)失败")
        }
        
        return Array()
    }
    

    //改-----涉及可变动参数太多，无法封装
}

