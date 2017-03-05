//
//  RSSSource+CoreDataProperties.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import CoreData


extension RSSSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSSource> {
        return NSFetchRequest<RSSSource>(entityName: "RSSSource");
    }

    @NSManaged public var title: String?
    @NSManaged public var rssURL: String?
    @NSManaged public var createDate: Date?
    @NSManaged public var rssNews: NSSet?

}

// MARK: Generated accessors for rssNews
extension RSSSource {

    @objc(addRssNewsObject:)
    @NSManaged public func addToRssNews(_ value: RSSNews)

    @objc(removeRssNewsObject:)
    @NSManaged public func removeFromRssNews(_ value: RSSNews)

    @objc(addRssNews:)
    @NSManaged public func addToRssNews(_ values: NSSet)

    @objc(removeRssNews:)
    @NSManaged public func removeFromRssNews(_ values: NSSet)

}
