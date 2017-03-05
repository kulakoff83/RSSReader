//
//  RequestService.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import PromiseKit

final class RequestService {
    
    static let shared = RequestService()
    
    func requestRSSSourcesWith(url: URL) -> Promise<[RSSSource]> {
        return firstly{
            return NetworkService.shared.requestWithURLPromise(url)
        }.then { object in
            return CoreDataStack.shared.createRSSSourcesWith(objects: object)
        }
    }
    
    func requestRSSSourceWith(url: URL) -> Promise<RSSSource> {
        return firstly{
            return NetworkService.shared.requestRSSFeedWithURLPromice(url)
        }.then { feed in
            return CoreDataStack.shared.createRSSSourceWith(rssFeed: feed)
        }
    }
    
}


