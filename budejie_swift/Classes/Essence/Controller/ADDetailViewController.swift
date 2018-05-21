//
//  ADDetailViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 4/2/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: UIImage? 

    override func viewDidLoad() {
        super.viewDidLoad()

        if let p = self.photo {
            self.imageView.image = p
        }
    }
    
    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
//        if #available(iOS 9.0, *) {
            let likeAction = UIPreviewAction(title: "like", style: UIPreviewActionStyle.default) { (action, vc) in
                print("like")
            }
            let dislikeAction = UIPreviewAction(title: "dislike", style: UIPreviewActionStyle.destructive) { (action, vc) in
                print("dislike")
            }
            return [likeAction, dislikeAction]
//        } else {
//            // Fallback on earlier versions
//            return super.previewActionItems
//        }
        
    }
    

}
