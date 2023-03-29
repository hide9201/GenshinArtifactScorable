//
//  AvatarInfo.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct AvatarInfo: Codable {
    
    let avatarId: Int
    let talentIdList: [Int]?
    let propMap: [String: PropValue]
    let fightPropMap: [String: Float]
    let skillLevelMap: [String: Int]
    let equipList: [Equip]
}

struct PropValue: Codable {
    let val: String?
}
