//
//  NSObject+Constants.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit


extension NSObject {
    
    public func adPrint(_ items: Any...) {
        print(items)
    }
    
    class func adClassPrint(_ items: Any...) {
        print(items)
    }
    
    func adColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        //        return UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    func adGlobalColor() -> UIColor {
        return UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0)
//        return UIColor(colorLiteralRed: 223 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
    }
    
    // OC的enum形式
    //    typedef enum {
    //    YZTopicTypeAll = 1,
    //    YZTopicTypePicture = 10,
    //    YZTopicTypeWord = 29,
    //    YZTopicTypeVoice = 31,
    //    YZTopicTypeVideo = 41
    //    } YZTopicType;
    
    // 精华Essence部分的帖子种类
    public enum ADTopicType: Int {
        case all = 1
        case picture = 10
        case word = 29
        case voice = 31
        case video = 41
    }
    
    
    public enum ADNotification: String {
        case tabBarDidSelect
        
        var stringValue: String {
            return "AD" + rawValue
        }
        
        var notificationName: Notification.Name {
            return NSNotification.Name(stringValue)
        }
    }
    
    
    /** 网路请求的url */
    public var budejie_url: String {
        return "http://api.budejie.com/api/api_open.php"
    }
    
    /** 屏幕尺寸 */
    public var ADScreenW: CGFloat { return UIScreen.main.bounds.width }
    public var ADScreenH: CGFloat { return UIScreen.main.bounds.height }
    public var ADScreenBounds: CGRect { return UIScreen.main.bounds }
    
    /** 精华－顶部标题的高度 */
    public var ADTitlesViewH: CGFloat { return 35 }
    
    /** 精华－顶部标题的Y */
    public var ADTitlesViewY: CGFloat { return 64 }
    
    /** 精华－cell间距 */
    public var ADTopicCellMargin: CGFloat { return 10 }
    
    /** 标签－间距 */
    public var ADTagMargin: CGFloat { return 5 }
    
    /** 精华－cell文字内容的Y值 */
    public var ADTopicCellTextY: CGFloat { return 55 }
    
    /** 精华－底部工具条的高度 */
    public var ADTopicCellBottomBarH: CGFloat { return 35 }
    
    /** 精华－cell－图片帖子的最大高度 */
    public var ADTopicCellPictureMaxH: CGFloat { return 1000 }
    
    /** 精华－cell－图片帖子一旦超过最大高度1000，就设置为此高度 */
    public var ADTopicCellPictureLimitH: CGFloat { return 250 }
    
    /** YZUser模型－性别属性值 */
    public enum ADUserGender: String {
        case male = "m"
        case female = "f"
    }
//    public var ADUserGenderMale: String { return "m" }
//    public var ADUserGenderFemale: String { return "f" }
    
    /** 精华－cell－“最热评论”4个字的高度 */
    public var ADTopicCellTopCmtTitleH: CGFloat { return 20 }
    
    /** tabBar被选中的通知的名字 */
    public var ADTabBarDidSelectNotification: String { return "YZTabBarDidSelectNotification" }
    
    /** tabBar被选中的通知 － 被选中的控制器的index key */
    public var ADSelectedControllerIndexKey: String { return "ADSelectedControllerIndexKey" }
    
    /** tabBar被选中的通知 － 被选中的控制器key */
    public var ADSelectedControllerKey: String { return "ADSelectedControllerKey" }
    
    /** 标签－高度 */
    public var ADTagH: CGFloat { return 25}
}
