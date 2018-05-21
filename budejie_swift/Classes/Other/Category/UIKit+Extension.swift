//
//  UIKit+Extension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

protocol NibLoadable {}
extension NibLoadable {
    static func loadFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

protocol RegisterCellNib {}
extension RegisterCellNib {
    static var identifier: String {
        return "\(self)"
    }
    static var nib: UINib? {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

extension UITableView {
    func ad_registerCell<T: UITableViewCell>(with cellClass: T.Type) where T: RegisterCellNib {
        if let nib = T.nib {
//            print(T.identifier)
            register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(cellClass, forCellReuseIdentifier: T.identifier)
        }
    }
    
    func ad_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellNib {
//        print(T.identifier)
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
