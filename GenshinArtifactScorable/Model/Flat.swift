//
//  Flat.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct Flat: Codable {
    
    let nameTextMapHash: String
    let setNameTextMapHash: String?
    let rankLevel: Int
    let reliquaryMainstat: ReliquaryMainStatus?
    let reliquarySubstats: [OtherEquipStatus]?
    let weaponStats: [OtherEquipStatus]?
    let itemType: String
    let icon: String
    let equipType: String?
}
