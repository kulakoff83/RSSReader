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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

fileprivate protocol Setup {
    func initialSetup()
}

fileprivate protocol Configuration {
    func configureTableView()
    func configureNavigationBar()
    func configureFetchResultController()
}

fileprivate protocol Request {
    func requestRSSList()
}

fileprivate protocol Actions {
    func addItemPressed()
}

fileprivate protocol Navigation {
    
}

extension RSSListViewController: Setup {
    
    func initialSetup() {
        self.requestRSSList()
        self.configureTableView()
        self.configureFetchResultController()
        self.configureNavigationBar()
    }
}

//MARK: Configuration

extension RSSListViewController: Configuration {
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.register(RSSListTableViewCell.nib, forCellReuseIdentifier: RSSListTableViewCell.reuseIdentifier)
    }
    
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
        self.title = "RSS Source List"
        let addItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItemPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
}

extension RSSListViewController: Request,BaseLoadViewProtocol  {
    
    func requestRSSList() {
        guard let sourceURL = URL(string: Constants.sourceURL) else { return }
        self.showLoadingView()
        firstly {
            RequestService.shared.requestRSSSourcesWith(url: sourceURL)
        }.then { sources -> Void in
            print(sources)
        }.always { [weak self] _ in
            self?.hideLoadingView()
        }.catch { error in
            self.showErrorAlert(title: error.localizedDescription)
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
        }.catch { error in
            self.showErrorAlert(title: error.localizedDescription)
            print(error)
        }
    }
}

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

extension RSSListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
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
                cell.configureCell(rssSource: record)
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

extension RSSListViewController: Actions {
    
    func addItemPressed() {
        let alert = Alert.addRSSAlert { [weak self] text in
            self?.requestRSS(link: text)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Navigation

extension RSSListViewController: Navigation {
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

     }

}
