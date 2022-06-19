//
//  ViewController.swift
//  TestProgressBar2
//
//  Created by 今橋浩樹 on 2022/06/19.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView = UIProgressView()

    override func loadView() {
        // webビューの定義
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavigationBarの下にUIprogressViewをBar形式で配置
        self.progressView = UIProgressView(frame: CGRect(x: 0.0, y:(self.navigationController?.navigationBar.frame.size.height)! - 3.0, width: self.view.frame.size.width, height: 3.0))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)
        
        // KVO監視
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        // URLリクエスト
        let url = URL(string: "https://www.yumemi.co.jp")
        self.webView.load(URLRequest(url: url!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0))

    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        self.webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    
    // 監視しているwkwebviewのestimatedProgressの値をUIProgressViewに反映
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
            if self.webView.isLoading {
                self.progressView.setProgress(0.1, animated: true)
            } else {
            self.progressView.setProgress(0.0, animated: false)
            }
        }
    }

}

