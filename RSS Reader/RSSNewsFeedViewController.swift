//
//  RSSNewsFeedViewController.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class RSSNewsFeedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var builder: TableViewCellBuilder = TableViewCellBuilder(tableView: self.tableView)
    var rssSource: RSSSource?
    fileprivate var fetchedResultsController: NSFetchedResultsController<RSSNews>?
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.newsDetails.identifier {
            let newsDetailsViewController = segue.destination as? RSSNewsDetailsViewController
            newsDetailsViewController?.rssNews = sender as? RSSNews
        }
    }

}

fileprivate protocol Request {
    func requestRSSNews()
}


extension RSSNewsFeedViewController: Setup {
    
    func initialSetup() {
        self.showLoadingView()
        self.requestRSSNews()
        self.setupTableView()
        self.configureFetchResultController()
        self.configureNavigationBar()
        self.configurePullToRefresh()
    }
    
    func setupTableView() {
        self.defaultConfigurationFor(tableView: self.tableView)
        self.tableView.register(RSSNewsTableViewCell.nib, forCellReuseIdentifier: RSSNewsTableViewCell.reuseIdentifier)
    }
}

//MARK: Configuration

extension RSSNewsFeedViewController: Configuration {
    
    func configureFetchResultController() {
        fetchedResultsController = CoreDataStack.shared.rssNewsFetchedResultsController
        fetchedResultsController?.fetchRequest.predicate = NSPredicate(format: "rssSource = %@",self.rssSource!)
        fetchedResultsController?.delegate = self
        do {
            try self.fetchedResultsController!.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func configureNavigationBar() {
        self.title = self.rssSource?.title
    }
    
    func configurePullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(requestRSSNews), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.layoutIfNeeded()
    }
}

extension RSSNewsFeedViewController: Request,BaseLoadViewProtocol  {
    
    func requestRSSNews() {
        guard let rssURLString = rssSource?.rssURL else { return }
        guard let rssURL = URL(string: rssURLString) else { return }
        firstly {
            RequestService.shared.requestRSSNewsFor(rssSource: rssSource!, url: rssURL)
        }.then { news -> Void in
            print(news)
        }.always { [weak self] _ in
            self?.hideLoadingView()
            self?.refreshControl.endRefreshing()
        }.catch { [weak self] error in
            self?.showErrorAlert(title: error.localizedDescription)
            print(error)
        }
    }
    
}

extension RSSNewsFeedViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        self.hideLoadingView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                let record = fetchedResultsController!.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! RSSNewsTableViewCell
                cell.configureCellWith(rssNews: record)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}

extension RSSNewsFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = fetchedResultsController!.object(at: indexPath)
        return self.builder.cellForRssNews(record, indexPath: indexPath)
    }
}

extension RSSNewsFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = fetchedResultsController!.object(at: indexPath)
        self.performSegue(withIdentifier: Segues.newsDetails.identifier, sender: record)
    }
}
