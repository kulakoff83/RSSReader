//
//  BaseTableViewCell.swift
//  RSS Reader
//
//  Created by Dmitry Kulakov on 05.03.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var nib: UINib {get}
    static var reuseIdentifier: String {get}
}

extension Reusable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return "\(String(describing: self))Identifier"
    }
}

class BaseTableViewCell: UITableViewCell,Reusable {
    
}
