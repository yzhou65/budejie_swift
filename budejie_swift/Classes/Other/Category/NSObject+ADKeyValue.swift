//
//  NSObject+ADKeyValue.swift
//  JSON解析
//
//  Created by Yue Zhou on 2/15/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

extension NSObject {
    
    /**
     * Dictionary array -> object array
     */
    class func objectsWithDictionaries(dictArr: [[String: Any]]) -> [NSObject] {
        var objects = [NSObject]()
        
        for dict in dictArr {
            objects.append(object(with: dict))
        }
        return objects
    }
    
    /**
     * Dictionary array -> object array
     */
    class func objectsWithDictionaries(dictArr: [[String: Any]], replacedKeyNames: [String: String]?) -> [NSObject] {
        var objects = [NSObject]()
        
        for dict in dictArr {
            objects.append(object(with: dict, replacedKeyNames: replacedKeyNames))
        }
        return objects
    }
    
    
    /**
     * Dictionary -> object
     */
    class func object(with dictionary: [String: Any]) -> Self {
        let obj = self.init()
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self.classForCoder();
        let properties = class_copyPropertyList(myClass, &count)!
//        let ivars = class_copyIvarList(myClass, &count)!
        
        
        for i: UInt32 in 0 ..< count {
            let property = properties[Int(i)]
            let cname = property_getName(property)
            let key = String(cString: cname!)
            
            // get the type of the property
            var propertyType = String.init(utf8String: property_copyAttributeValue(property, "T"))!
            
            if var val: Any = dictionary[key] {
                
                if (val as AnyObject).isKind(of: NSClassFromString("__NSCFDictionary")!) && !propertyType.contains("NS") {
                    
                    // T@"_TtC31Runtime_swift字典转模型KVC4User"
                    // parse the string and get the class name "User"
                    let projectNameRange = propertyType.range(of: projectName)!
                    let classRange = Range<String.Index>(uncheckedBounds: (lower: propertyType.index(after: projectNameRange.upperBound), upper: propertyType.index(before: propertyType.endIndex)))
                    propertyType = projectName + "." + propertyType.substring(with: classRange)
                    //                    print(propertyType)
                    
                    if let modelClass = NSClassFromString(propertyType) {
                        val = modelClass.object(with: val as! [String: Any])
                        
                    }
                }
                
                obj.setValue(val, forKey: key)
            }
        }
        free(properties)
        return obj
    }
    
    
    /**
     * Dictionary -> object
     */
    class func object(with dictionary: [String: Any], replacedKeyNames: [String: String]?) -> Self {
        let obj = self.init()
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self.classForCoder();
        let properties = class_copyPropertyList(myClass, &count)!
        //        let ivars = class_copyIvarList(myClass, &count)!
        
        for i: UInt32 in 0 ..< count {
            let property = properties[Int(i)]
            let cname = property_getName(property)
            let key = String(cString: cname!)
            
            // get the type of the property
            var propertyType = String.init(utf8String: property_copyAttributeValue(property, "T"))!
            
            var val = dictionary[key]
//            print("\(key): \(propertyType), value: \(type(of: dictionary[key]))")
            if let value: Any = val {
//                print("\(key): \(propertyType), value: \(type(of: value))")
                
                if ((value as AnyObject).isKind(of: NSClassFromString("__NSCFDictionary")!) || (value as AnyObject).isKind(of: NSClassFromString("__NSDictionaryI")!)) && !propertyType.contains("NS") {
                    
                    // ex: T@"_TtC31Runtime_swiftKVC4User"
                    // parse the string and get the class name "User"
                    let projectNameRange = propertyType.range(of: projectName)!
                    let classRange = Range<String.Index>(uncheckedBounds: (lower: propertyType.index(after: projectNameRange.upperBound), upper: propertyType.index(before: propertyType.endIndex)))
                    propertyType = projectName + "." + propertyType.substring(with: classRange)
                    //                    print(propertyType)
                    
                    if let modelClass = NSClassFromString(propertyType) {
                        val = modelClass.object(with: val as! [String: Any])
                        
                    }
                }
                
                obj.setValue(val, forKey: key)
            }
            else {
                if replacedKeyNames == nil || replacedKeyNames![key] == nil {
                    continue
                }
                
                val = dictionary[replacedKeyNames![key]!]
                if let value: Any = val {
                    
                    if ((value as AnyObject).isKind(of: NSClassFromString("__NSCFDictionary")!) || (value as AnyObject).isKind(of: NSClassFromString("__NSDictionaryI")!)) && !propertyType.contains("NS") {
                        
                        // T@"_TtC31Runtime_swiftKVC4User"
                        // parse the string and get the class name "User"
                        let projectNameRange = propertyType.range(of: projectName)!
                        let classRange = Range<String.Index>(uncheckedBounds: (lower: propertyType.index(after: projectNameRange.upperBound), upper: propertyType.index(before: propertyType.endIndex)))
                        propertyType = projectName + "." + String(propertyType[classRange])
//                        propertyType = projectName + "." + propertyType.substring(with: classRange)
                        //                    print(propertyType)
                        
                        if let modelClass = NSClassFromString(propertyType) {
                            val = modelClass.object(with: val as! [String: Any])
                            
                        }
                    }
                    
                    obj.setValue(val, forKey: key)
                }
            }
        }
        free(properties)
        return obj
    }
    
    
    class func objectsWithFile(named: String) -> [NSObject] {
        var objects = [NSObject]()
        let file = Bundle.main.path(forResource: named, ofType: nil)
        let dictArr = NSArray(contentsOfFile: file!)!
        
        for dict in dictArr as! [[String: Any]] {
            objects.append(object(with: dict))
        }
        return objects
    }
}
