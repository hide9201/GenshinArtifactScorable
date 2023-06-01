//
//  ShapedAccountAllInfo.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/11.
//

import Foundation

struct ShapedAccountAllInfo {
    let uid: String
    let nextRefreshableDate: Date
    let playerBasicInfo: PlayerBasicInfo
    let characters: [Character]
    
    init(accountAllInfo: AccountAllInfo, localizedDictionary: [String: String], characterMap: [String: CharacterMap.Character], nameCardMap: [String: NameCardMap.NameCard]) {
        uid = accountAllInfo.uid
        nextRefreshableDate = Calendar.current.date(byAdding: .second, value: accountAllInfo.ttl ?? 30, to: Date())!
        playerBasicInfo = .init(playerInfo: accountAllInfo.playerInfo, characterMap: characterMap, nameCardMap: nameCardMap)
        if let avatarInfoList = accountAllInfo.avatarInfoList {
            characters = avatarInfoList.compactMap { avatarInfo in
                    .init(avatarInfo: avatarInfo, localizedDictionary: localizedDictionary, characterMap: characterMap)
            }
        } else { characters = .init() }
    }
    
    init(uid: String, nextRefreshableDate: Date, playerBasicInfo: PlayerBasicInfo, characters: [Character]) {
        self.uid = uid
        self.nextRefreshableDate = nextRefreshableDate
        self.playerBasicInfo = playerBasicInfo
        self.characters = characters
    }
}
    
struct PlayerBasicInfo {
    let playerName: String
    let adventureLevel: Int
    let statusMessage: String
    let worldLevel: Int
    let nameCardString: String
    let profilePictureCharacterIconString: String
    
    init(playerInfo: AccountAllInfo.PlayerInfo, characterMap: [String: CharacterMap.Character], nameCardMap: [String: NameCardMap.NameCard]) {
        playerName = playerInfo.nickname
        adventureLevel = playerInfo.level
        statusMessage = playerInfo.signature ?? "ステータスメッセージを設定していません"
        worldLevel = playerInfo.worldLevel
        nameCardString = nameCardMap["\(playerInfo.nameCardId)"]?.icon ?? ""
        profilePictureCharacterIconString = characterMap["\(playerInfo.profilePicture.avatarId)"]?.sideIconName.replacingOccurrences(of: "_Side", with: "") ?? ""
    }
    
    init(playerName: String, adventureLevel: Int, statusMessage: String, worldLevel: Int, nameCardString: String, profilePictureCharacterIconString: String) {
        self.playerName = playerName
        self.adventureLevel = adventureLevel
        self.statusMessage = statusMessage
        self.worldLevel = worldLevel
        self.nameCardString = nameCardString
        self.profilePictureCharacterIconString = profilePictureCharacterIconString
    }
}

struct Character {
    let name: String
    let element: Element
    let constellationLevel: Int
    let constellationStrings: [String]
    let skills: [Skill]
    let level: Int
    let friendshipLevel: Int
    let weapon: Weapon
    let artifacts: [Artifact]
    let fightPropMap: FightPropMap
    let iconString: String
    let sideIconString: String
    let quality: Quality
    
    private var nameID: String { iconString.replacingOccurrences(of: "UI_AvatarIcon_", with: "") }
    var imageString: String { "UI_Gacha_AvatarImg_\(nameID)" }
    var namecardIconString: String {
        if nameID == "PlayerGirl" || nameID == "PlayerBoy" {
            return "UI_NameCardPic_Bp2_P"
        } else if nameID == "Yae" {
            return "UI_NameCardPic_Yae1_P"
        } else {
            return "UI_NameCardPic_\(nameID)_P"
        }
    }
    
    init?(avatarInfo: AccountAllInfo.AvatarInfo, localizedDictionary: [String: String], characterMap: [String: CharacterMap.Character]) {
        guard let character = characterMap["\(avatarInfo.avatarId)-\(avatarInfo.skillDepotId)"] ?? characterMap["\(avatarInfo.avatarId)"] else { return nil }
        
        name = localizedDictionary.nameFrom(id: character.nameTextMapHash)
        element = Element.init(rawValue: character.elementMap[character.element] ?? "") ?? .unknown
        
        if let talentIdList = avatarInfo.talentIdList {
            constellationLevel = talentIdList.count
        } else {
            constellationLevel = 0
        }
        constellationStrings = character.constellationStrings
        
        iconString = character.sideIconName.replacingOccurrences(of: "_Side", with: "")
        sideIconString = character.sideIconName
        
        skills = character.skillOrder.map({ skillID in
            let level = avatarInfo.skillLevelMap.skillLevel.first { key, value in
                key == String(skillID)
            }?.value ?? 0
            let icon = character.skills.skillData[String(skillID)] ?? "unknown"
            let adjustedDelta = avatarInfo.proudSkillExtraLevelMap?[(character.proudMap.proudData[skillID.description] ?? 0).description] ?? 0
            
            return Skill(skillID: skillID, level: level, levelAdjusted: level + adjustedDelta ,iconString: icon)
        })
        
        level = Int(avatarInfo.propMap.level.val) ?? 0
        friendshipLevel = avatarInfo.fetterInfo.expLevel
        
        guard let weaponEquipment = avatarInfo.equipList.first(where: { equipment in
            equipment.flat.itemType == "ITEM_WEAPON"
        }) else { return nil }
        weapon = .init(weaponEquipment: weaponEquipment, localizedDictionary: localizedDictionary)!
        
        artifacts = avatarInfo.equipList.filter({ equip in
            equip.flat.itemType == "ITEM_RELIQUARY"
        }).compactMap({ artifactEquipment in
                .init(artifactEquipment: artifactEquipment, localizedDictionary: localizedDictionary)
        })
        
        fightPropMap = avatarInfo.fightPropMap
        quality = .init(rawValue: character.qualityType) ?? .purple
    }
    
    init(name: String, element: Element, constellationLevel: Int, constellationStrings: [String], skills: [Skill], level: Int, friendshipLevel: Int, weapon: Weapon, artifacts: [Artifact], fightPropMap: FightPropMap, iconString: String, sideIconString: String,  quality: Quality) {
        self.name = name
        self.element = element
        self.constellationLevel = constellationLevel
        self.constellationStrings = constellationStrings
        self.skills = skills
        self.level = level
        self.friendshipLevel = friendshipLevel
        self.weapon = weapon
        self.artifacts = artifacts
        self.fightPropMap = fightPropMap
        self.iconString = iconString
        self.sideIconString = sideIconString
        self.quality = quality
    }
    
    enum Element: String {
        case cryo = "Cryo"
        case anemo = "Anemo"
        case electro = "Electro"
        case hydro = "Hydro"
        case pyro = "Pyro"
        case geo = "Geo"
        case dendro = "Dendro"
        case unknown
    }
    
    enum Quality: String {
        case purple = "QUALITY_PURPLE"
        case orange = "QUALITY_ORANGE"
        /// アーロイ用
        case orangeSpecial = "QUALITY_ORANGE_SP"
        
        var characterBackgroundIconString: String {
            switch self {
            case .purple:
                return "QualityBackground/Quality_4_background"
            case .orange:
                return "QualityBackground/Quality_5_background"
            case .orangeSpecial:
                return "QualityBackground/Quality_5sp_background"
            }
        }
    }
}
        
struct Skill {
    let skillID: Int
    let level: Int
    let levelAdjusted: Int
    let iconString: String
}
        
struct Weapon {
    let name: String
    let level: Int
    let refinementRank: Int
    let mainAttribute: Attribute
    let subAttribute: Attribute?
    let iconString: String
    let rankLevel: RankLevel
    var awakenedIconString: String { "\(iconString)_Awaken" }
    
    init?(weaponEquipment: AccountAllInfo.AvatarInfo.Equip, localizedDictionary: [String: String]) {
        guard weaponEquipment.flat.itemType == "ITEM_WEAPON" else { return nil }
        name = localizedDictionary.nameFrom(id: weaponEquipment.flat.nameTextMapHash)
        level = weaponEquipment.weapon!.level
        refinementRank = (weaponEquipment.weapon!.affixMap?.affix.first?.value ?? 0) + 1

        let mainAttributeName = localizedDictionary.nameFrom(id: "FIGHT_PROP_BASE_ATTACK")
        let mainAttributeValue = weaponEquipment.flat.weaponStats?.first(where: { stats in
            stats.appendPropId == "FIGHT_PROP_BASE_ATTACK"
        })?.statValue ?? 0
        mainAttribute = .init(propId: "FIGHT_PROP_BASE_ATTACK", name: mainAttributeName, value: mainAttributeValue)

        if weaponEquipment.flat.weaponStats?.first(where: { stats in
            stats.appendPropId != "FIGHT_PROP_BASE_ATTACK"
        }) != nil {
            let subStats = weaponEquipment.flat.weaponStats?.first(where: { stats in
                stats.appendPropId != "FIGHT_PROP_BASE_ATTACK"
            })
            let subAttributeName = localizedDictionary.nameFrom(id: subStats?.appendPropId ?? "")
            let subAttributeValue = subStats?.statValue ?? 0
            subAttribute = .init(propId: subStats?.appendPropId ?? "unknown", name: subAttributeName, value: subAttributeValue)
        } else {
            subAttribute = nil
        }

        iconString = weaponEquipment.flat.icon
        rankLevel = .init(rawValue: weaponEquipment.flat.rankLevel) ?? .one
    }
    
    init(name: String, level: Int, refinementRank: Int, mainAttribute: Attribute, subAttribute: Attribute?, iconString: String, rankLevel: RankLevel) {
        self.name = name
        self.level = level
        self.refinementRank = refinementRank
        self.mainAttribute = mainAttribute
        self.subAttribute = subAttribute
        self.iconString = iconString
        self.rankLevel = rankLevel
    }
    
    init() {
        self.name = ""
        self.level = 0
        self.refinementRank = 0
        self.mainAttribute = Attribute(propId: "", name: "", value: 0)
        self.subAttribute = nil
        self.iconString = ""
        self.rankLevel = .one
    }
}
        
struct Artifact {
    let id: String
    let name: String
    let setName: String
    let mainAttribute: Attribute
    let subAttributes: [Attribute]
    let iconString: String
    let artifactType: ArtifactType
    let rankLevel: RankLevel
    
    enum ArtifactType: String, CaseIterable {
        case flower = "EQUIP_BRACER"
        case plume = "EQUIP_NECKLACE"
        case sands = "EQUIP_SHOES"
        case goblet = "EQUIP_RING"
        case circlet = "EQUIP_DRESS"
    }
    
    init?(artifactEquipment: AccountAllInfo.AvatarInfo.Equip, localizedDictionary: [String: String]) {
        guard artifactEquipment.flat.itemType == "ITEM_RELIQUARY" else { return nil }
        id = artifactEquipment.flat.nameTextMapHash
        name = localizedDictionary.nameFrom(id: artifactEquipment.flat.nameTextMapHash)
        setName = localizedDictionary.nameFrom(id: artifactEquipment.flat.setNameTextMapHash!)
        
        mainAttribute = Attribute(propId: artifactEquipment.flat.reliquaryMainstat!.mainPropId, name: localizedDictionary.nameFrom(id: artifactEquipment.flat.reliquaryMainstat!.mainPropId), value: artifactEquipment.flat.reliquaryMainstat!.statValue)
        
        subAttributes = artifactEquipment.flat.reliquarySubstats?.map({ stats in
            Attribute(propId: stats.appendPropId, name: localizedDictionary.nameFrom(id: stats.appendPropId), value: stats.statValue)
        }) ?? []
        
        iconString = artifactEquipment.flat.icon
        artifactType = .init(rawValue: artifactEquipment.flat.equipType ?? "") ?? .flower
        rankLevel = .init(rawValue: artifactEquipment.flat.rankLevel) ?? .five
    }
    
    init(id: String, name: String, setName: String, mainAttribute: Attribute, subAttributes: [Attribute], iconString: String, artifactType: ArtifactType, rankLevel: RankLevel) {
        self.id = id
        self.name = name
        self.setName = setName
        self.mainAttribute = mainAttribute
        self.subAttributes = subAttributes
        self.iconString = iconString
        self.artifactType = artifactType
        self.rankLevel = rankLevel
    }
}
        
struct Attribute {
    let propId: String
    var propIconString: String { propId.replacingOccurrences(of: "FIGHT_PROP_", with: "") }
    let name: String
    var valueString: String { String(format: "%.1f", value) }
    var value: Double
    init(propId: String, name: String, value: Double) {
        self.propId = propId
        self.name = name
        self.value = value
    }
}

private extension Dictionary where Key == String, Value == String {
    func nameFrom(id: Int) -> String {
        self["\(id)"] ?? "unknown"
    }
    func nameFrom(id: String) -> String {
        self[id] ?? "unknown"
    }
}

enum RankLevel: Int {
    case one = 1, two = 2, three = 3, four = 4, five = 5
    var rectangularBackgroundIconString: String {
        "UI_QualityBg_\(self.rawValue)"
    }
    var squaredBackgroundIconString: String {
        "UI_QualityBg_\(self.rawValue)s"
    }
}

extension Character: Scorable {
    func calculateCriticalScore() -> Double {
        return artifacts.reduce(0) { $0 + $1.calculateCriticalScore() }
    }
    
    func calculateTotalScore(criteria: ScoreCriteria) -> Double {
        return artifacts.reduce(0) { $0 + $1.calculateTotalScore(criteria: criteria) }
    }
}

extension Artifact: Scorable {
    func calculateCriticalScore() -> Double {
        return subAttributes.reduce(0) { (result, attribute) -> Double in
            switch attribute.propId {
            case "FIGHT_PROP_CRITICAL":
                return result + attribute.value * 2
            case "FIGHT_PROP_CRITICAL_HURT":
                return result + attribute.value
            default:
                return result
            }
        }
    }
    
    func calculateTotalScore(criteria: ScoreCriteria) -> Double {
        var score = calculateCriticalScore()
        
        switch criteria {
        case .attack:
            score += subAttributes.reduce(0) { (result, attribute) -> Double in
                switch attribute.propId {
                case "FIGHT_PROP_ATTACK_PERCENT":
                    return result + attribute.value
                default:
                    return result
                }
            }
        case .hp:
            score += subAttributes.reduce(0) { (result, attribute) -> Double in
                switch attribute.propId {
                case "FIGHT_PROP_HP_PERCENT":
                    return result + attribute.value
                default:
                    return result
                }
            }
        case .defense:
            score += subAttributes.reduce(0) { (result, attribute) -> Double in
                switch attribute.propId {
                case "FIGHT_PROP_DEFENSE_PERCENT":
                    return result + attribute.value
                default:
                    return result
                }
            }
        case .energyRecharge:
            score += subAttributes.reduce(0) { (result, attribute) -> Double in
                switch attribute.propId {
                case "FIGHT_PROP_CHARGE_EFFICIENCY":
                    return result + attribute.value
                default:
                    return result
                }
            }
        case .elementalMastery:
            score += subAttributes.reduce(0) { (result, attribute) -> Double in
                switch attribute.propId {
                case "FIGHT_PROP_ELEMENT_MASTERY":
                    return result + attribute.value / 4
                default:
                    return result
                }
            }
        }
        
        return score
    }
}
