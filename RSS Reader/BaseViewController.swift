//
//  BaseViewController.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

protocol Setup {
    func initialSetup()
    func setupTableView()
}

protocol Configuration {
    func configureNavigationBar()
    func configureFetchResultController()
    func configurePullToRefresh()
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorAlert(title: String) {
        let alert = Alert.errorAlert(title: title)
        self.present(alert, animated: true, completion: nil)
    }
    
    func defaultConfigurationFor(tableView: UITableView) {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

}
