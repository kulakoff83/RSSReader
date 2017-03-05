//
//  Extensions.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

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
