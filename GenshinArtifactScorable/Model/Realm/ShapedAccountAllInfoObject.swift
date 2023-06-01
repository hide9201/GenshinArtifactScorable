//
//  ShapedAccountAllInfoObject.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/26.
//

import Foundation
import RealmSwift

final class ShapedAccountAllInfoObject: Object {
    
    @Persisted(primaryKey: true) var uid = ""
    @Persisted var nextRefreshableDate = Date()
    @Persisted var playerBasicInfo: PlayerBasicInfoObject? = nil
    
    @Persisted var  characters = List<CharacterObject>()
}
    
final class PlayerBasicInfoObject: Object {
    
    @Persisted var playerName = ""
    @Persisted var adventureLevel = 0
    @Persisted var statusMessage = ""
    @Persisted var worldLevel = 0
    @Persisted var nameCardString = ""
    @Persisted var profilePictureCharacterIconString = ""
}
    
final class CharacterObject: Object {
    
    @Persisted var name = ""
    @Persisted var element = ""
    @Persisted var constellationLevel = 0
    @Persisted var level = 0
    @Persisted var friendshipLevel = 0
    @Persisted var weapon: WeaponObject? = nil
    @Persisted var fightPropMap: FightPropMapObject? = nil
    @Persisted var iconString = ""
    @Persisted var sideIconString = ""
    @Persisted var quality = ""
    
    @Persisted var constellationStrings = List<String>()
    @Persisted var skills = List<SkillObject>()
    @Persisted var artifacts = List<ArtifactObject>()
}
        
final class WeaponObject: Object {
    
    @Persisted var name = ""
    @Persisted var level = 0
    @Persisted var refinementRank = 0
    @Persisted var mainAttribute: AttributeObject? = nil
    @Persisted var subAttribute: AttributeObject? = nil
    @Persisted var iconString = ""
    @Persisted var rankLevel = 0
}
        
final class SkillObject: Object {
    
    @Persisted var skillID = 0
    @Persisted var level = 0
    @Persisted var levelAdjusted = 0
    @Persisted var iconString = ""
}
        
final class ArtifactObject: Object {

    @Persisted var id = ""
    @Persisted var name = ""
    @Persisted var setName = ""
    @Persisted var mainAttribute: AttributeObject? = nil
    @Persisted var iconString = ""
    @Persisted var artifactType = ""
    @Persisted var rankLevel = 0

    @Persisted var subAttributes = List<AttributeObject>()
}
        
final class AttributeObject: Object {
    
    @Persisted var propId = ""
    @Persisted var propIconString = ""
    @Persisted var name = ""
    @Persisted var propValue = 0.0
}

extension ShapedAccountAllInfoObject {
    
    static func decode(from value: ShapedAccountAllInfo) -> ShapedAccountAllInfoObject {
        
        let shapedAccountAllInfoObject = ShapedAccountAllInfoObject()
        shapedAccountAllInfoObject.uid = value.uid
        shapedAccountAllInfoObject.nextRefreshableDate = value.nextRefreshableDate
        shapedAccountAllInfoObject.playerBasicInfo = PlayerBasicInfoObject.decode(from: value.playerBasicInfo)
        shapedAccountAllInfoObject.characters.append(objectsIn: value.characters.compactMap { CharacterObject.decode(from: $0) })
        
        return shapedAccountAllInfoObject
    }
    
    var value: ShapedAccountAllInfo? {
        guard let playerBasicInfo = playerBasicInfo else { return nil }
        return ShapedAccountAllInfo(uid: uid, nextRefreshableDate: nextRefreshableDate, playerBasicInfo: playerBasicInfo.value, characters: characters.compactMap { $0.value })
    }
}

extension PlayerBasicInfoObject {
    
    static func decode(from value: PlayerBasicInfo) -> PlayerBasicInfoObject {
        
        let playerBasicInfoObject = PlayerBasicInfoObject()
        playerBasicInfoObject.playerName = value.playerName
        playerBasicInfoObject.adventureLevel = value.adventureLevel
        playerBasicInfoObject.statusMessage = value.statusMessage
        playerBasicInfoObject.worldLevel = value.worldLevel
        playerBasicInfoObject.nameCardString = value.nameCardString
        playerBasicInfoObject.profilePictureCharacterIconString = value.profilePictureCharacterIconString
        
        return playerBasicInfoObject
    }
    
    var value: PlayerBasicInfo {
        return PlayerBasicInfo(playerName: playerName, adventureLevel: adventureLevel, statusMessage: statusMessage, worldLevel: worldLevel, nameCardString: nameCardString, profilePictureCharacterIconString: profilePictureCharacterIconString)
    }
}

extension CharacterObject {
    
    static func decode(from value: Character) -> CharacterObject {
        
        let characterObject = CharacterObject()
        
        characterObject.name = value.name
        characterObject.element = value.element.rawValue
        characterObject.constellationLevel = value.constellationLevel
        characterObject.constellationStrings.append(objectsIn: value.constellationStrings)
        characterObject.skills.append(objectsIn: value.skills.map {
            SkillObject.decode(from: $0)
        })
        
        characterObject.level = value.level
        characterObject.friendshipLevel = value.friendshipLevel
        characterObject.weapon = WeaponObject.decode(from: value.weapon)
        characterObject.artifacts.append(objectsIn: value.artifacts.map {
            ArtifactObject.decode(from: $0)
        })
        characterObject.fightPropMap = FightPropMapObject.decode(from: value.fightPropMap)
        characterObject.iconString = value.iconString
        characterObject.sideIconString = value.sideIconString
        characterObject.quality = value.quality.rawValue
        
        return characterObject
    }
    
    var value: Character? {
        guard let weapon = weapon, let fightPropMap = fightPropMap else { return nil }
        return Character(name: name, element: Character.Element(rawValue: element) ?? .unknown, constellationLevel: constellationLevel, constellationStrings: constellationStrings.map { $0 }, skills: skills.map { $0.value }, level: level, friendshipLevel: friendshipLevel, weapon: weapon.value ?? Weapon(), artifacts: artifacts.compactMap { $0.value }, fightPropMap: fightPropMap.value,iconString: iconString, sideIconString: sideIconString, quality: Character.Quality(rawValue: quality) ?? .orange)
    }
}

extension WeaponObject {
    
    static func decode(from value: Weapon) -> WeaponObject {
        
        let weaponObject = WeaponObject()
        weaponObject.name = value.name
        weaponObject.level = value.level
        weaponObject.refinementRank = value.refinementRank
        weaponObject.iconString = value.iconString
        weaponObject.rankLevel = value.rankLevel.rawValue
        
        weaponObject.mainAttribute = AttributeObject.decode(from: value.mainAttribute)
        
        if let subAttribute = value.subAttribute {
            weaponObject.subAttribute = AttributeObject.decode(from: subAttribute)
        } else {
            weaponObject.subAttribute = nil
        }
        
        return weaponObject
    }
    
    var value: Weapon? {
        guard let mainAttribute = mainAttribute else { return nil }
        return Weapon(name: name, level: level, refinementRank: refinementRank, mainAttribute: mainAttribute.value, subAttribute: subAttribute?.value, iconString: iconString, rankLevel: RankLevel(rawValue: rankLevel) ?? .one)
    }
}

extension AttributeObject {
    
    static func decode(from value: Attribute) -> AttributeObject {
        
        let attributeObject = AttributeObject()
        attributeObject.propId = value.propId
        attributeObject.propIconString = value.propIconString
        attributeObject.name = value.name
        attributeObject.propValue = value.value
        
        return attributeObject
    }
    
    var value: Attribute {
        return Attribute(propId: propId, name: name, value: propValue)
    }
}

extension SkillObject {
    
    static func decode(from value: Skill) -> SkillObject {
        
        let skillObject = SkillObject()
        skillObject.skillID = value.skillID
        skillObject.level = value.level
        skillObject.levelAdjusted = value.levelAdjusted
        skillObject.iconString = value.iconString
        
        return skillObject
    }
    
    var value: Skill {
        return Skill(skillID: skillID, level: level, levelAdjusted: levelAdjusted, iconString: iconString)
    }
}

extension ArtifactObject {
    
    static func decode(from value: Artifact) -> ArtifactObject {
        
        let artifactObject = ArtifactObject()
        artifactObject.id = value.id
        artifactObject.name = value.name
        artifactObject.setName = value.setName
        artifactObject.mainAttribute = AttributeObject.decode(from: value.mainAttribute)
        artifactObject.subAttributes.append(objectsIn: value.subAttributes.map {
            AttributeObject.decode(from: $0)
        })
        artifactObject.iconString = value.iconString
        artifactObject.artifactType = value.artifactType.rawValue
        artifactObject.rankLevel = value.rankLevel.rawValue
        
        return artifactObject
    }
    
    var value: Artifact? {
        guard let mainAttribute = mainAttribute else { return nil }
        return Artifact(id: id, name: name, setName: setName, mainAttribute: mainAttribute.value, subAttributes: subAttributes.map { $0.value }, iconString: iconString, artifactType: Artifact.ArtifactType(rawValue: artifactType) ?? .flower, rankLevel: RankLevel(rawValue: rankLevel) ?? .five)
    }
}
