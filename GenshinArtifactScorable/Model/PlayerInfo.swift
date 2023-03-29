//
//  PlayerInfo.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct PlayerInfo: Codable {
    
    let nickname: String
    let signature: String?
    let level: Int
    let worldLevel: Int
    let nameCardId: Int
    let finishAchievementNum: Int
    let towerFloorIndex: Int
    let towerLevelIndex: Int
    let profilePicture: ProfilePicture
}

struct ProfilePicture: Codable {
    
    let avatarId: Int
}
