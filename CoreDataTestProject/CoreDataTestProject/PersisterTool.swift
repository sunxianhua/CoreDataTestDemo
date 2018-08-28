//
//  PersisterTool.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/27.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//


import Foundation
enum DocumentsPathType :String{
    case documents_Type  = "/Documents"
    case Caches_Type     = "/Library/Caches"
    case Preference_Type = "/Library/Preference"
    case temp_Type       = "/tmp/"
}

class PersistenceTool: NSObject {
    
    //*******存储路径*****
    /// 沙盒Documents目录
    static let DocumentsPath  = NSHomeDirectory() + "/Documents"
    /// 沙盒Library目录
    static let LibraryPath    = NSHomeDirectory() + "/Library"
    /// 沙盒Caches目录
    static let CachesPath     = NSHomeDirectory() + "/Library/Caches"
    /// 沙盒Preference目录
    static let PreferencePath = NSHomeDirectory() + "/Library/Preference"
    /// 沙盒temp目录
    static let TempPath = NSTemporaryDirectory()
    
    
    /*
       获取沙盒路径
     */
    //获取到某条路径的相对路径， 因为iOS8 之后，沙盒主目录的路径会动态变化，所以每次都要取相对路径
    class func getCorrectPathWith(filePath :String,pathType :DocumentsPathType?) ->String?{
        
        if let theType = pathType {
            
            //能够明确文件存储的沙盒主目录类型时
            return PersistenceTool.getPathWith(pathType: theType, filePath: filePath)
            
        }

        
        //不能够明确文件存储的沙盒主目录类型时，通过路径字段判断
        var thePathType :DocumentsPathType?
        if filePath.contains("/Documents/") {
            thePathType = DocumentsPathType.documents_Type
        }
        if filePath.contains("/Library/Caches/") {
            thePathType = DocumentsPathType.Caches_Type
        }
        if filePath.contains("/Library/Preference/") {
            thePathType = DocumentsPathType.Preference_Type
        }
        if filePath.contains("/tmp/") {
            thePathType = DocumentsPathType.temp_Type
        }
        
        
        
        return thePathType == nil ? nil : self.getPathWith(pathType: thePathType!, filePath: filePath)
        
    }
    
    
    //根据类型直接获得 相对路径 (这种方法要注意 子路径里面不能有主路径相同文件 例如 /Caches/)
    class private func getPathWith(pathType :DocumentsPathType,filePath :String) ->String? {
        
        //能够明确文件存储的沙盒主目录类型时
        var pathArray :[String] = filePath.components(separatedBy: pathType.rawValue)
        if pathArray.count < 2 {
            return nil
        }
        
        pathArray[0] = PersistenceTool.getRelativePath(pathType: pathType)
        return pathArray[0] + pathArray[1]
        
    }
    
    
    //根据类型获得相对路径的主目录
    class func getRelativePath(pathType :DocumentsPathType) ->String{
        
        return pathType == .temp_Type ? NSTemporaryDirectory() : NSHomeDirectory() + pathType.rawValue
    }
    
    
    /**
     存储配置文件
     - parameter key:         配置标记
     - parameter stringValue: 配置值
     */
    class func savePrefWithKey(key: String,object: Any){
        
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }
    
    
    func getObgectWithKey(key: String) -> Any?{
        
        let defaults = UserDefaults.standard
        return  defaults.object(forKey: key) as Any?
    }
    
    
    
    /*
        根据路径存取
     */
    
    //存字符串
    class func saveStringToPath(savePath :String,saveString :String) ->Bool{
        
        do {
            try saveString.write(toFile: savePath, atomically: true, encoding: String.Encoding.utf8)
            return true
            
        } catch{
            debugPrint("存入字符串失败查看对应文件夹是否未创建")
        }
        
        return false
        
    }
    
    
    //取存储的字符串
    class func getStringFromePath(savePath :String) -> String {
        
        let fileManager = FileManager.default
        
        if let data = fileManager.contents(atPath: savePath) {
            
            if let dataString = String.init(data: data, encoding: String.Encoding.utf8) {
                
                return dataString
            }
        }
        
        debugPrint("取值出错")
        return ""
    }
    
    
    //创建对应路径文件夹
    class func creatUserFiles(filePath :String) -> Bool{
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            
            return true
        } catch {
            
            print("路径创建失败")
            return false
        }
    }
    
    
    //检测文件是否存在
    class func checkPath(savePath :String) ->Bool{
        
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: savePath)
    }
    
    
    //删除文件
    class func removeFiles(savePath :String) ->Bool{
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: savePath)
            
            return true
        } catch {
            print("删除失败")
            return false
        }
    }
    
    
}
