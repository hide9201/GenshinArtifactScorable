//
//  NSObject+.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import Foundation

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
