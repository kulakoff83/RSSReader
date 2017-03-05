//
//  NetworkService.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireRSSParser
import PromiseKit
import ObjectMapper

final class NetworkService {
    
    static let shared = NetworkService()
    
    private func sendRequestWithURL(_ url: URL, completion: @escaping (Alamofire.Result<Any>) -> ()) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestWithURLPromise(_ url: URL) -> Promise<[AnyObject]>{
        return Promise { fulfill, reject in
            self.sendRequestWithURL(url, completion: { result in
                switch result {
                case .success:
                    guard let data = (result.value as? [String: AnyObject])?["result"] as? [AnyObject] else { return }
                    fulfill(data)
                case .failure:
                    reject(result.error!)
                }
            })
        }
    }
    
    func requestRSSFeedWithURLPromice(_ url: URL) -> Promise<RSSFeed> {
        return Promise { fulfill, reject in
            Alamofire.request(url).responseRSS() { (response) -> Void in
                if let feed: RSSFeed = response.result.value {
                    feed.link = "\(url)"
                    fulfill(feed)
                } else {
                    if let error = response.result.error {
                        reject(error)
                    } else {
                        let error = NSError(domain: "requestRSS", code: 123, userInfo: nil)//create specific error
                        reject(error)
                    }
                }
            }
        }
    }
}
