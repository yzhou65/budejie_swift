//
//  ADProgressView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/6/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import DACircularProgress

class ADProgressView: DALabeledCircularProgressView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundedCorners = 2
        self.progressLabel.textColor = UIColor.white
    }

    override func setProgress(_ progress: CGFloat, animated: Bool) {
        super.setProgress(progress, animated: animated)
        
        let text = String(format: "%.0f%%", progress * 100)
        self.progressLabel.text = text.replacingOccurrences(of: "-", with: "")
    }

}
