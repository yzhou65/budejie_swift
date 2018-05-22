//
//  ADMeFooterCollectionView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let maxCols: Int = 5    // 一行最多4列方格
private let margin: CGFloat = 5

class ADMeFooterCollectionView: UICollectionView, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.squares.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let btn = ADSquareButton(type: UIButtonType.custom)
        
        // 监听
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        btn.square = self.squares[indexPath.item]
        let buttonWH = (ADScreenW - margin * CGFloat(maxCols - 1)) / CGFloat(maxCols)
        btn.frame = CGRect(x: 0, y: 0, width: buttonWH, height: buttonWH)
        cell.backgroundColor = .blue
        cell.addSubview(btn)
        return cell
    }
    
    var squares = [Square]() {
        didSet {
            let row = (squares.count - 1) / maxCols + 1
            let buttonWH = (ADScreenW - margin * CGFloat(maxCols - 1)) / CGFloat(maxCols)
            self.size = CGSize(width: ADScreenW, height: CGFloat(row) * (buttonWH + margin))
            self.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clear
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(_ btn: ADSquareButton) {
        if !btn.square.url.hasPrefix("http") {
            return
        }
        
        let webVC = ADWebViewController()
        webVC.url = btn.square.url
        webVC.title = btn.square.name
        
        // 取出当前导航控制器
        let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! UITabBarController
        let nav = tabBarVC.selectedViewController as! UINavigationController
        nav.pushViewController(webVC, animated: true)
    }
}


class ADMeCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        self.minimumLineSpacing = margin
        self.minimumInteritemSpacing = margin
        
        let buttonWH = (ADScreenW - margin * CGFloat(maxCols - 1)) / CGFloat(maxCols)
        self.itemSize = CGSize(width: buttonWH, height: buttonWH)
    }
}
