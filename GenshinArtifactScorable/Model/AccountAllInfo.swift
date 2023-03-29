//
//  AccountAllInfo.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/19.
//

import Foundation

struct AccountAllInfo: Codable {
    
    let playerInfo: PlayerInfo
    let avatarInfoList: [AvatarInfo]?
}
