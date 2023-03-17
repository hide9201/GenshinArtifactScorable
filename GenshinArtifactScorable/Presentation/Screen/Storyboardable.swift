//
//  Storyboardable.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit
import Instantiate

typealias Storyboardable = StoryboardInstantiatable

extension Storyboardable where Self: UIViewController {
    
    static var storyboardName: StoryboardName {
        return className.replacingOccurrences(of: "ViewController", with: "")
    }
}
