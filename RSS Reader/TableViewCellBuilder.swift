//
//  TableViewCellBuilder.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

private protocol TableViewCellBuilderInterface: class {
    func cellForRssList(_ rssSource: RSSSource, indexPath: IndexPath) -> UITableViewCell
    func cellForRssNews(_ rssNews: RSSNews, indexPath: IndexPath) -> UITableViewCell
    func cellForDetailsRssNews(_ rssNews: RSSNews,delegate: RSSNewsDetailsViewController,contentHeight: CGFloat, indexPath: IndexPath) -> UITableViewCell
}

final class TableViewCellBuilder {
    
    //MARK: Properties
    fileprivate let tableView: UITableView
    
    //MARK: LifeCycle
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    fileprivate init?(){
        return nil
    }
}

//MARK: TableViewCellBuilder

extension TableViewCellBuilder: TableViewCellBuilderInterface {
    
    func cellForRssList(_ rssSource: RSSSource, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSListTableViewCell.reuseIdentifier) as! RSSListTableViewCell
        cell.configureCellWith(rssSource: rssSource)
        return cell
    }
    
    func cellForRssNews(_ rssNews: RSSNews, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSNewsTableViewCell.reuseIdentifier) as! RSSNewsTableViewCell
        cell.configureCellWith(rssNews: rssNews)
        return cell
    }
    
    func cellForDetailsRssNews(_ rssNews: RSSNews,delegate: RSSNewsDetailsViewController,contentHeight: CGFloat, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSNewsDetailsTableViewCell.reuseIdentifier) as! RSSNewsDetailsTableViewCell
        cell.newsDescriptionWebView.delegate = delegate
        cell.newsDescriptionWebView.tag = indexPath.row
        cell.contentHeight = contentHeight
        cell.handler = { [weak self] in
            cell.newsDescriptionWebView.layoutIfNeeded()
            self?.tableView.reloadData()
        }
        cell.configureCellWith(rssNews: rssNews)
        return cell
    }
}
