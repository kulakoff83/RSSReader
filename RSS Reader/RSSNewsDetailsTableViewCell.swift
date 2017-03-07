//
//  RSSNewsDetailsTableViewCell.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 06.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit


class RSSNewsDetailsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newsDescriptionWebView: UIWebView!
    var handler = {() -> (Void) in }
    var contentHeight : CGFloat = 0.0
    fileprivate var sourceURLString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sourceButtonPressed(_ sender: Any) {
        if let sourceURL = URL(string: self.sourceURLString) {
            UIApplication.shared.open(sourceURL, options: [:], completionHandler: nil)
        }
    }
}

extension RSSNewsDetailsTableViewCell: RSSNewsTableViewCellConfiguration {
    
    func configureCellWith(rssNews: RSSNews) {
        self.dateLabel.text = rssNews.pubDate?.dateString()
        self.titleLabel.text = rssNews.title
        self.configureWebViewWith(text: rssNews.newsDescription)

        guard let urlString = rssNews.link else {
            return
        }
        self.sourceURLString = urlString
    }
    
    func configureWebViewWith(text: String?) {
        guard let newsDescription = text else { return}
        let font = UIFont.systemFont(ofSize: 14)
        var modifiedString = NSString(format:"<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize);color: #000000\">%@</span>" as NSString, newsDescription) as String
        modifiedString = modifiedString.addResponsiveImageStyleToHtmlString()
        self.newsDescriptionWebView.dataDetectorTypes = []
        self.webViewHeight.constant = contentHeight
        self.newsDescriptionWebView.scrollView.isScrollEnabled = false
        self.newsDescriptionWebView.loadHTMLString(modifiedString, baseURL: nil)
    }
}
