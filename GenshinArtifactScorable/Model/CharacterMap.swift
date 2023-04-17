//
//  CharacterMap.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/11.
//

import Foundation

struct CharacterMap: Codable {
    var characterStaticData: [String: Character]
    
    struct CharacterKey: CodingKey {
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
        let container = try decoder.container(keyedBy: CharacterKey.self)
        
        var character = [String: Character]()
        for key in container.allKeys {
            if let model = try? container.decode(Character.self, forKey: key) {
                character[key.stringValue] = model
            }
        }
        self.characterStaticData = character
    }
    
    struct Character: Codable {
        let element: String
        let consts: [String]
        let skillOrder: [Int]
        let skills: Skill
        let nameTextMapHash: Int
        let proudMap: ProudMap
        let sideIconName: String
        var iconString: String { sideIconName.replacingOccurrences(of: "_Side", with: "") }
        var nameID: String { iconString.replacingOccurrences(of: "UI_AvatarIcon_", with: "") }
        let qualityType: String
        var namecardIconString: String {
            if nameID == "PlayerGirl" || nameID == "PlayerBoy" {
                return "UI_NameCardPic_Bp2_P"
            } else if nameID == "Yae" {
                return "UI_NameCardPic_Yae1_P"
            } else {
                return "UI_NameCardPic_\(nameID)_P"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case element = "Element"
            case consts = "Consts"
            case skillOrder = "SkillOrder"
            case skills = "Skills"
            case nameTextMapHash = "NameTextMapHash"
            case proudMap = "ProudMap"
            case sideIconName = "SideIconName"
            case qualityType = "QualityType"
        }
        
        struct Skill: Codable {
            var skillData: [String: String]
            
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
                
                var skill = [String: String]()
                for key in container.allKeys {
                    if let model = try? container.decode(String.self, forKey: key) {
                        skill[key.stringValue] = model
                    }
                }
                self.skillData = skill
            }
        }
         
        struct ProudMap: Codable {
            var proudData: [String: Int]
            
            struct ProudKey: CodingKey {
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
                let container = try decoder.container(keyedBy: ProudKey.self)
                
                var proudData = [String: Int]()
                for key in container.allKeys {
                    if let model = try? container.decodeIfPresent(Int.self, forKey: key) {
                        proudData[key.stringValue] = model
                    }
                }
                self.proudData = proudData
            }
        }
    }
}
