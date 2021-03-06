//
//  RSSListViewController.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit
import PromiseKit
import CoreData

class RSSListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var builder: TableViewCellBuilder = TableViewCellBuilder(tableView: self.tableView)
    fileprivate var fetchedResultsController: NSFetchedResultsController<RSSSource>?
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
        if segue.identifier == Segues.newsFeed.identifier {
            let newsFeedViewController = segue.destination as? RSSNewsFeedViewController
            newsFeedViewController?.rssSource = sender as? RSSSource
        }
    }
}

fileprivate protocol Request {
    func requestRSSList()
    func requestRSS(link: String)
}

fileprivate protocol Actions {
    func addItemPressed()
}

//MARK: Setup

extension RSSListViewController: Setup {
    
    func initialSetup() {
        self.showLoadingView()
        self.requestRSSList()
        self.setupTableView()
        self.configureFetchResultController()
        self.configureNavigationBar()
        self.configurePullToRefresh()
    }
    
    func setupTableView() {
        self.defaultConfigurationFor(tableView: self.tableView)
        self.tableView.register(RSSListTableViewCell.nib, forCellReuseIdentifier: RSSListTableViewCell.reuseIdentifier)
    }
}

//MARK: Configuration

extension RSSListViewController: Configuration {
    
    func configureFetchResultController() {
        fetchedResultsController = CoreDataStack.shared.rssSourceFetchedResultsController
        fetchedResultsController?.delegate = self
        do {
            try self.fetchedResultsController!.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func configureNavigationBar() {
        self.title = "RSS"
        let addItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItemPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    func configurePullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(requestRSSList), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.layoutIfNeeded()
    }
}

//MARK: Request

extension RSSListViewController: Request,BaseLoadViewProtocol  {
    
    func requestRSSList() {
        guard let sourceURL = URL(string: Constants.SourceURL) else { return }
        firstly {
            RequestService.shared.requestRSSSourcesWith(url: sourceURL)
        }.then { sources -> Void in
            print(sources)
        }.always { [weak self] _ in
            self?.hideLoadingView()
            self?.refreshControl.endRefreshing()
        }.catch { [weak self] error in
            self?.showErrorAlert(title: error.localizedDescription)
           print(error)
        }
    }
    
    func requestRSS(link: String) {
        guard let rssURL = URL(string: link) else { return }
        self.showLoadingView()
        firstly {
            RequestService.shared.requestRSSSourceWith(url: rssURL)
        }.then { source -> Void in
            print(source)
        }.always { [weak self] _ in
            self?.hideLoadingView()
        }.catch { [weak self] error in
            self?.showErrorAlert(title: error.localizedDescription)
            print(error)
        }
    }
}

//MARK: UITableViewDataSource

extension RSSListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = fetchedResultsController!.object(at: indexPath)
        return self.builder.cellForRssList(record, indexPath: indexPath)
    }
}

//MARK: UITableViewDelegate

extension RSSListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = fetchedResultsController!.object(at: indexPath)
        self.performSegue(withIdentifier: Segues.newsFeed.identifier, sender: record)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record = fetchedResultsController!.object(at: indexPath)
            self.fetchedResultsController!.managedObjectContext.delete(record)
        }
    }
}

//MARK: NSFetchedResultsControllerDelegate

extension RSSListViewController: NSFetchedResultsControllerDelegate {
    
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
                let cell = tableView.cellForRow(at: indexPath) as! RSSListTableViewCell
                cell.configureCellWith(rssSource: record)
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

//MARK: Actions

extension RSSListViewController: Actions {
    
    func addItemPressed() {
        let alert = Alert.addRSSAlert { [weak self] text in
            self?.requestRSS(link: text)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

