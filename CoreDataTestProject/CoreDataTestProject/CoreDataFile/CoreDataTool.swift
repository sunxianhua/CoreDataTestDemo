//
//  CoreDataTool.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2019/1/18.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//  coreData 使用封装 工具类----使用时只需拷贝该文件

import Foundation
import CoreData
class CoreDataTool<N :NSManagedObject>: NSObject{
    
    var coreDataText :NSManagedObjectContext!
    init(modelName :String){
        super.init()
        self.coreDataText = CoreDataTool.creatContextWithObjModelName(modelName: modelName)
    }
    
    /// 获取 与模型文件绑定的对应的 存储数据管理上下文
    ///
    /// - Parameter modelName: 模型文件
    /// - Returns: 返回关联好的上下文
    class func creatContextWithObjModelName(modelName :String) ->NSManagedObjectContext?{
        
        //初始化管理数据对象的上下文
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        
        
        //******配置上下文关联属性****
        //创建对应的模型文件（即可视化操作所有Entity的.xcdatamodeld 文件）
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            return nil
        }
        
        guard let fileModel = NSManagedObjectModel.init(contentsOf: modelURL) else {
            return nil
        }
        
        
        //创建对应的持久化调度器---该调度器主要 用于 数据存储层 和 对象模型层 之间的 协调通信（任何对数据库的操作，都需要由 context 通过 其执行）
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: fileModel)
        // 关联对应的 数据存储空间 -- 决定将数据存储在什么位置，以何种方式存储
        guard let sqlitePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return nil
        }
        
        let pathString = sqlitePath.appending("/\(modelName).splite")
        let sqliteUrl = URL.init(fileURLWithPath: pathString)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteUrl, options: nil)
            context.persistentStoreCoordinator = coordinator
            
            //返回做好关联的 管理上下文
            return context
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
    
    
    
    /// 增加一个表 数据模型实例
    ///
    /// - Parameters:
    ///   - entityName: 对应的表名称
    /// - Returns: 实例
    func creatEntityModel(entityName :String) ->N?{
        
        let entityModel = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.coreDataText)
        return entityModel as? N
    }
    
    
    /// 存储数据
    /// - Returns: 存储结果
    func saveContext() ->Bool{
        guard self.coreDataText.hasChanges else { return false}
        
        do {
            try self.coreDataText.save()
            return true
            
        } catch let error as NSError {
            debugPrint("Unclear error\(error)")
        }
        
        return false
    }
    
    
    //删
    func delete(obj :NSManagedObject) ->Bool{
        self.coreDataText.delete(obj)
        return self.saveContext()
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
            let resultArray = try self.coreDataText.fetch(theFetchRequest) as! [N]
            return resultArray
        }catch {
            fatalError("查找\(entityName)失败")
        }
        
        return Array()
    }

    
    
}
