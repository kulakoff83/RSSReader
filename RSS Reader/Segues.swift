//
//  Segues.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 06.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation

public enum Segues {
    
    case newsFeed
    case newsDetails
    
    public var identifier: String {
        switch self {
        case .newsFeed:
            return "ToNewsFeedController"
        case .newsDetails:
            return "ToNewsDetailsViewController"
        }
    }
}
