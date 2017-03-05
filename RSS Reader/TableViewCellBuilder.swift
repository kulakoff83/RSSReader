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
        cell.configureCell(rssSource: rssSource)
        return cell
    }
    
}