//
//  Weapon.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct Weapon: Codable {
    
    let level: Int
    let promoteLevel: Int
    let affixMap: [String: Int]
}
