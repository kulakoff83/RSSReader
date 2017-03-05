//
//  RSSSource+CoreDataClass.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
import AlamofireRSSParser


public class RSSSource: NSManagedObject, Mappable {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required public init(map: Map) {
        let context = CoreDataStack.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "RSSSource", in: context)!
        super.init(entity: entity, insertInto: context)
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        self.rssURL <- map["rssURL"]
        self.title <- map["title"]
        self.createDate = Date()
    }
    
    public init(title: String, link: String) {
        let context = CoreDataStack.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "RSSSource", in: context)!
        super.init(entity: entity, insertInto: context)
        self.title = title
        self.rssURL = link
    }

}
