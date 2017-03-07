//
//  RSSNewsDetailsViewController.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

class RSSNewsDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var builder: TableViewCellBuilder = TableViewCellBuilder(tableView: self.tableView)
    var rssNews: RSSNews?
    fileprivate var contentHeight : CGFloat = 0.0
    fileprivate let cellCount = 1
    fileprivate var webView: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView?.delegate = nil
    }
}

// MARK: Setup

extension RSSNewsDetailsViewController: Setup {
    
    func initialSetup() {
        self.setupTableView()
    }
    
    func setupTableView() {
        self.defaultConfigurationFor(tableView: self.tableView)
        self.tableView.register(RSSNewsDetailsTableViewCell.nib, forCellReuseIdentifier: RSSNewsDetailsTableViewCell.reuseIdentifier)
    }
}

// MARK: UITableViewDataSource

extension RSSNewsDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.builder.cellForDetailsRssNews(rssNews!, delegate: self,
                                                  contentHeight: contentHeight, indexPath: indexPath)
    }
}

// MARK: WebViewDelegate

extension RSSNewsDetailsViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.webView == nil {
            self.webView = webView
        }
        if (contentHeight != 0.0) {
            return
        }
        var frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        let fittingSize = webView.sizeThatFits(CGSize(width:0, height:0))
        frame.size = fittingSize;
        webView.frame = frame;
        contentHeight = frame.height
        contentHeight = webView.scrollView.contentSize.height
        webView.layoutIfNeeded()
        tableView.reloadData()
    }
}
