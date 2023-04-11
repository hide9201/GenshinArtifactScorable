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
    let ttl: Int?
    let uid: String
    
    struct PlayerInfo: Codable {
        
        let nickname: String
        let signature: String?
        let level: Int
        let worldLevel: Int
        let nameCardId: Int
        let finishAchievementNum: Int
        let towerFloorIndex: Int?
        let towerLevelIndex: Int?
        let profilePicture: ProfilePicture
        
        struct ProfilePicture: Codable {
            
            let avatarId: Int
        }
    }
    
    struct AvatarInfo: Codable {
        
        let avatarId: Int
        let talentIdList: [Int]?
        let propMap: PropMap
        let fightPropMap: FightPropMap
        let skillLevelMap: SkillLevelMap
        let equipList: [Equip]
        let fetterInfo: FetterInfo
        
        struct PropMap: Codable {
            
            let level: Level
            
            struct Level: Codable {
                
                let type: Int
                let val: String
            }
            
            private enum CodingKeys: String, CodingKey {
                
                case level = "4001"
            }
        }
        
        struct SkillLevelMap: Codable {
            
            var skillLevel: [String: Int]
            
            struct SkillKey: CodingKey {
                
                var stringValue: String
                var intValue: Int?
                
                init?(stringValue: String) {
                    self.stringValue = stringValue
                }
                
                init?(intValue: Int) {
                    self.stringValue = "\(intValue)"
                    self.intValue = intValue
                }
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: SkillKey.self)
                
                var skill = [String: Int]()
                for key in container.allKeys {
                    if let model = try? container.decode(Int.self, forKey: key) {
                        skill[key.stringValue] = model
                    }
                }
                self.skillLevel = skill
            }
        }
        
        struct Equip: Codable {
            
            let itemId: Int
            let weapon: Weapon?
            let reliquary: Reliquary?
            let flat: Flat
            
            struct Weapon: Codable {
                
                let level: Int
                let promoteLevel: Int?
                let affixMap: [String: Int]?
            }
            
            struct Reliquary: Codable {
                
                let level: Int
            }
            
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
                
                struct ReliquaryMainStatus: Codable {
                    
                    let mainPropId: String
                    let statValue: Float
                }
                
                struct OtherEquipStatus: Codable {
                    
                    let appendPropId: String
                    let statValue: Float
                }
            }
        }
        
        struct FetterInfo: Codable {
            var expLevel: Int
        }
    }
}
