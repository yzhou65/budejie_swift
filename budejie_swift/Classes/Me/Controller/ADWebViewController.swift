//
//  ADWebViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import NJKWebViewProgress
import SafariServices

class ADWebViewController: UIViewController, UIWebViewDelegate {
    // MARK: - 子控件, 成员变量
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    
    /** 待加载的url */
    var url: String = ""
    
    /** 进度代理对象 */
    var progress: NJKWebViewProgress?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.progress = NJKWebViewProgress()
        self.webView.delegate = self.progress
        
        self.progress!.progressBlock = { [weak self](progress: Float) in
            self?.progressView.progress = progress

            // 这个if可以造成webView加载的进度条永远停留在99%的假象
//            if progress >= 1.0 {
//                self?.progressView.progress = 0.99
//            }
            self?.progressView.isHidden = (self?.progressView.progress == 1.0)
        }
        
        self.webView.loadRequest(URLRequest(url: URL(string: self.url)!))
    }
    
    // MARK: - 按钮监听
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.backItem.isEnabled = webView.canGoBack
        self.forwardItem.isEnabled = webView.canGoForward
    }
    
}
