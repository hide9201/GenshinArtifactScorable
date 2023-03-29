//
//  Equip.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct Equip: Codable {
    
    let itemId: Int
    let weapon: Weapon?
    let reliquary: Reliquary?
    let flat: Flat
}
