//
//  CoreDataStack.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
import PromiseKit
import AlamofireRSSParser

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    func createRSSSourcesWith(objects: [AnyObject]) -> Promise<[RSSSource]> {
        return Promise { fulfill, reject in
            var sources = [RSSSource]()
            for object in objects {
                if let rssSourceJSON  = object as? [String : Any] {
                    guard let link = rssSourceJSON["rssURL"] as? String else {
                        
                        return
                    }
                    if !self.rssSourceIsExistWith(link: link) {
                        if let source = Mapper<RSSSource>().map(JSON: rssSourceJSON) {
                            sources.append(source)
                        } else {
                            let error = NSError(domain: "createSourcesWith", code: 123, userInfo: nil)//create specific error
                            reject(error)
                        }
                    }
                }
            }
//            if sources.count == 0 {
//                let error = NSError(domain: "createSourcesWith", code: 123, userInfo: nil)//create specific error
//                reject(error)
//            }
            self.saveContext()
            fulfill(sources)
        }
    }
    
    func createRSSSourceWith(rssFeed: RSSFeed) -> Promise<RSSSource> {
        return Promise { fulfill, reject in
            if let link = rssFeed.link, let title = rssFeed.title {
                let rssSource = RSSSource(title: title, link: link)
                self.saveContext()
                fulfill(rssSource)
            } else {
                let error = NSError(domain: "createRSSSourceWith", code: 123, userInfo: nil)//create specific error
                reject(error)
            }
        }
    }
    
    func updateRSSSource(rssSource: RSSSource, rssFeed: RSSFeed) -> Promise<[RSSNews]> {
        return Promise { fulfill, reject in
            var newsArray = [RSSNews]()
            for item in rssFeed.items {
                if let link = item.link {
                    if !self.rssNewsIsExistWith(link: link) {
                        let rssNews = RSSNews(rssItem: item)
                        newsArray.append(rssNews)
                    }
                }
            }
            let news = NSSet().addingObjects(from: newsArray) as NSSet
            rssSource.addToRssNews(news)
            self.saveContext()
            fulfill(Array(news) as! [RSSNews])
        }
    }
    
    func rssSourceIsExistWith(link: String) -> Bool {
        let fetchRequest: NSFetchRequest<RSSSource> = RSSSource.fetchRequest()
        let predicate = NSPredicate(format: "rssURL == %@", link)
        fetchRequest.predicate = predicate
        return self.objectIsExistWith(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    }
    
    func rssNewsIsExistWith(link: String) -> Bool {
        let fetchRequest: NSFetchRequest<RSSNews> = RSSNews.fetchRequest()
        let predicate = NSPredicate(format: "link == %@", link)
        fetchRequest.predicate = predicate
        return self.objectIsExistWith(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    }
    
    func objectIsExistWith(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> Bool {
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var rssSourceFetchedResultsController: NSFetchedResultsController<RSSSource> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<RSSSource> = RSSSource.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    lazy var rssNewsFetchedResultsController: NSFetchedResultsController<RSSNews> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<RSSNews> = RSSNews.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RSS_Reader")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
