//
//  RSSNewsTableViewCell.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 06.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

protocol RSSNewsTableViewCellConfiguration: class {
    func configureCellWith(rssNews: RSSNews)
}

class RSSNewsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: Configuration

extension RSSNewsTableViewCell: RSSNewsTableViewCellConfiguration {
    func configureCellWith(rssNews: RSSNews) {
        self.titleLabel?.text = rssNews.title
        self.dateLabel?.text = rssNews.pubDate?.dateString()
    }
}
