//
//  RSSNews+CoreDataClass.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import CoreData
import AlamofireRSSParser

public class RSSNews: NSManagedObject {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(rssItem: RSSItem) {
        let context = CoreDataStack.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "RSSNews", in: context)!
        super.init(entity: entity, insertInto: context)
        self.title = rssItem.title
        self.link = rssItem.link
        self.newsDescription = rssItem.itemDescription
        self.pubDate = rssItem.pubDate
    }
}
