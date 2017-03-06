//
//  RSSNews+CoreDataProperties.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import CoreData


extension RSSNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSNews> {
        return NSFetchRequest<RSSNews>(entityName: "RSSNews");
    }

    @NSManaged public var title: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var pubDate: Date?
    @NSManaged public var link: String?
    @NSManaged public var rssSource: RSSSource?

}
