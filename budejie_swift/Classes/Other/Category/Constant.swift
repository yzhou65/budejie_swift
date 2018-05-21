//
//  Constant.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

enum ADNotification: String {
    case tabBarDidSelect
    
    var stringValue: String {
        return "AD" + rawValue
    }
    
    var notificationName: Notification.Name {
        return NSNotification.Name(stringValue)
    }
}


/** 网路请求的url */
public var budejie_url: String  = "http://api.budejie.com/api/api_open.php"

/** 屏幕尺寸 */
public let ADScreenW: CGFloat = UIScreen.main.bounds.width
public let ADScreenH: CGFloat = UIScreen.main.bounds.height
public let ADScreenBounds: CGRect = UIScreen.main.bounds

/** 精华－顶部标题的高度 */
public let ADTitlesViewH: CGFloat = 35

/** 精华－顶部标题的Y */
public let ADTitlesViewY: CGFloat = 64

/** 精华－cell间距 */
public let ADTopicCellMargin: CGFloat = 10

/** 标签－间距 */
public let ADTagMargin: CGFloat = 5

/** 精华－cell文字内容的Y值 */
public let ADTopicCellTextY: CGFloat = 55

/** 精华－底部工具条的高度 */
public let ADTopicCellBottomBarH: CGFloat = 35

/** 精华－cell－图片帖子的最大高度 */
public let ADTopicCellPictureMaxH: CGFloat = 1000

/** 精华－cell－图片帖子一旦超过最大高度1000，就设置为此高度 */
public let ADTopicCellPictureLimitH: CGFloat = 250

/** YZUser模型－性别属性值 */
enum ADUserGender: String {
    case male = "m"
    case female = "f"
}
//    public var ADUserGenderMale: String { return "m" }
//    public var ADUserGenderFemale: String { return "f" }

/** 精华－cell－“最热评论”4个字的高度 */
public let ADTopicCellTopCmtTitleH: CGFloat = 20

/** tabBar被选中的通知的名字 */
public let ADTabBarDidSelectNotification: String = "YZTabBarDidSelectNotification"

/** tabBar被选中的通知 － 被选中的控制器的index key */
public let ADSelectedControllerIndexKey: String = "ADSelectedControllerIndexKey"

/** tabBar被选中的通知 － 被选中的控制器key */
public let ADSelectedControllerKey: String = "ADSelectedControllerKey"

/** 标签－高度 */
public let ADTagH: CGFloat = 25

func adColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    //        return UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
}

func adGlobalColor() -> UIColor {
    return UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0)
    //        return UIColor(colorLiteralRed: 223 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
}
