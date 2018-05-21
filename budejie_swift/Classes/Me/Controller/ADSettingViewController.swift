//
//  ADSettingViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let id = "setting"

class ADSettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        self.tableView.backgroundColor = adGlobalColor()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id)!
        let size = Double(SDImageCache.shared().getSize()) / 1000.0 / 1000.0  // mac的文件按1000来计算K M G
        cell.textLabel?.text = String(format: "清除缓存(已使用%.2fMB)", size)
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SDImageCache.shared().clearDisk()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 获得cache文件大小的例子

    /**
     遍历文件，计算文件总大小. 示例2
     */
    private func getSize2() {
        // 图片缓存
        let size = SDImageCache.shared().getSize()
        print(size)
        
        // 文件夹
        let caches = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        let path = caches!.appendingPathComponent("default/com.hackemist.SDWebImageCache.default")
        
        //获得文件夹内部的所有内容
        do {
            try FileManager.default.contentsOfDirectory(atPath: path.absoluteString)
        } catch {
            print(error)
        }
        print(FileManager.default.subpaths(atPath: path.absoluteString) ?? "")
    }
    
    /**
     遍历文件，计算文件总大小. 示例1
     */
    private func getSize() {
        // 文件夹
        let caches = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        let cachePath = caches!.appendingPathComponent("default/com.hackemist.SDWebImageCache.default")
        
        let fileEnumerator = FileManager.default.enumerator(atPath: cachePath.absoluteString)!
        var totalSize = 0
        for fileName in fileEnumerator {
            let filePath = cachePath.appendingPathComponent(fileName as! String)
            
            // 判断文件是否是文件夹
//            var dir: ObjCBool = false
//            if FileManager.default.fileExists(atPath: filePath.absoluteString, isDirectory: &dir) {
//                continue
//            }
            
            // 判断文件是否是文件夹
            var attrs = [FileAttributeKey: Any]()
            do {
                attrs = try FileManager.default.attributesOfItem(atPath: filePath.absoluteString)
                if attrs[FileAttributeKey.type] as! FileAttributeType == FileAttributeType.typeDirectory {
                    continue
                }
            } catch {
                print(error)
            }
            totalSize += (attrs[FileAttributeKey.size] as! Int)
        }
    }

}
