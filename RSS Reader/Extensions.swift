//
//  Extensions.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

//MARK: UIViewController,BaseLoadViewProtocol

protocol BaseLoadViewProtocol { }

extension BaseLoadViewProtocol where Self: UIViewController {
    
    func showLoadingView() {
        let loadView = LoadingView(frame: self.view.bounds)
        self.navigationController?.view.addSubview(loadView)
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        loadView.startIndicator()
    }
    
    func hideLoadingView() {
        var loadView: LoadingView? = self.navigationController?.view.subviews.last as? LoadingView
        guard let subviews = self.navigationController?.view.subviews else {
            return
        }
        for view in subviews {
            if view is LoadingView {
                loadView = view as? LoadingView
            }
        }
        self.navigationController?.view.isUserInteractionEnabled = true
        self.view.isUserInteractionEnabled = true
        loadView?.removeFromSuperview()
        loadView?.stopIndicator()
    }
}

//MARK: Date

extension Date {
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let defaultTimeZoneStr = formatter.string(from: self)
        return defaultTimeZoneStr
    }
    
}

//MARK: String

extension String {
    func addResponsiveImageStyleToHtmlString() -> String {
        return
            "<head>" +
                "   <style>" +
                "        img{max-width: 100%; max-height: auto;}" +
                "        iframe{max-width: 100%; max-height: auto;}" +
                "   </style>" +
                "</head>" +
        self
    }
}

extension UIRefreshControl {
    func beginRefreshingWithTableView(tableView: UITableView) {
        self.beginRefreshing()
        if tableView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
                tableView.contentOffset = CGPoint(x:0,y: -self.frame.size.height)
            })
        }

    }
}
