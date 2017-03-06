//
//  RSSListTableViewCell.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

private protocol RSSListTableViewCellConfiguration: class {
    func configureCellWith(rssSource: RSSSource)
}

class RSSListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
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

extension RSSListTableViewCell: RSSListTableViewCellConfiguration {
    func configureCellWith(rssSource: RSSSource) {
        self.iconImageView?.image = UIImage(named: "rss_icon")
        self.titleLabel?.text = rssSource.title
    }
}
