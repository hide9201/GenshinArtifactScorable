//
//  BuildCardGeneratable.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/31.
//

import Foundation
import UIKit

protocol BuildCardGeneratable {
}

extension BuildCardGeneratable {
    
    func generateBuildCard(character: Character,
                           characterImage: UIImage,
                           weaponImage: UIImage,
                           skillIcons: [UIImage],
                           constellationIcons: [UIImage],
                           artifactImages: [UIImage?]) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1920, height: 1080), false, 0)
        
        let genshinUIFontName = "SDK_JP_Web"
        
        let buildCardBaseImage = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")!
        buildCardBaseImage.draw(in: CGRect(x: 0, y: 0, width: 1920, height: 1080))
        
        // characterImageはアスペクト比がキャラ毎に違うので，アスペクト比固定で最大サイズに合わせる
        // characterImageMaxHeightはもうちょい小さくてもいいかも，画像の横がはみ出るようならcharacterImageMaxHeightを小さくしてみる
        let characterImageMaxWidth: CGFloat = 756
        let characterImageMaxHeight: CGFloat = 646
        let characterImageScale = characterImageMaxHeight / characterImage.size.height
        let characterImageWidth = characterImage.size.width * characterImageScale
        let characterImageHeight = characterImage.size.height * characterImageScale
        characterImage.draw(in: CGRect(x: (characterImageMaxWidth - characterImageWidth) / 2, y: (characterImageMaxHeight - characterImageHeight) / 2, width: characterImageWidth, height: characterImageHeight))
        
        let characterNameFont = UIFont(name: genshinUIFontName, size: 48)!
        let characterName = NSString(string: character.name)
        let characterNameX: CGFloat = 32
        let characterNameY: CGFloat = 32
        characterName.draw(at: CGPoint(x: characterNameX, y: characterNameY), withAttributes: [
            NSAttributedString.Key.font: characterNameFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let characterLevelFont = UIFont(name: genshinUIFontName, size: 28)!
        let characterLevelString = NSString(string: String("Lv.\(character.level)"))
        let characterLevelX: CGFloat = characterNameX
        let characterLevelY: CGFloat = characterNameY + characterNameFont.pointSize + 4
        characterLevelString.draw(at: CGPoint(x: characterLevelX, y: characterLevelY), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let friendshipIcon = UIImage(named: "BuildCard/Friendship")!
        let friendshipIconX: CGFloat = characterLevelX + CGFloat(characterLevelString.length - 2) * characterLevelFont.pointSize
        let friendshipIconY: CGFloat = characterLevelY + 2
        let friendshipIconWidth: CGFloat = 34
        let friendshipIconHeight: CGFloat = 28
        friendshipIcon.draw(in: CGRect(x: friendshipIconX, y: friendshipIconY, width: friendshipIconWidth, height: friendshipIconHeight))
        
        let friendshipLevel = NSString(string: String(character.friendshipLevel))
        let friendshipLevelX: CGFloat = friendshipIconX + friendshipIconWidth
        let friendshipLevelY: CGFloat = characterLevelY
        friendshipLevel.draw(at: CGPoint(x: friendshipLevelX, y: friendshipLevelY), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponInfoBaseX: CGFloat = 1436
        let weaponInfoBaseY: CGFloat = 44
        let weaponImageWidth: CGFloat = 128
        let weaponImageHeight: CGFloat = 128
        weaponImage.draw(in: CGRect(x: weaponInfoBaseX, y: weaponInfoBaseY, width: weaponImageWidth, height: weaponImageHeight)) // 1418, 32
        
        let weaponRealityIcon = UIImage(named: "BuildCard/WeaponRealityIcon/\(character.weapon.rankLevel.rawValue)")!
        let weaponRealityIconWidth: CGFloat = 153
        let weaponRealityIconHeight: CGFloat = 33
        weaponRealityIcon.draw(in: CGRect(x: weaponInfoBaseX - 16, y: weaponInfoBaseY + weaponImageHeight, width: weaponRealityIconWidth, height: weaponRealityIconHeight))
        
        let weaponRefinementRankFont = UIFont(name: genshinUIFontName, size: 26)!
        let weaponRefinementRankString = NSString(string: "R\(character.weapon.refinementRank)")
        let weaponRefinementRankX: CGFloat = weaponInfoBaseX
        let weaponRefinementRankY: CGFloat = weaponInfoBaseY
        weaponRefinementRankString.draw(at: CGPoint(x: weaponRefinementRankX, y: weaponRefinementRankY), withAttributes: [
            NSAttributedString.Key.font: weaponRefinementRankFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponNameFont = UIFont(name: genshinUIFontName, size: 26)!
        let weaponName = NSString(string: character.weapon.name)
        let weaponNameX: CGFloat = weaponInfoBaseX + weaponImageWidth + 20
        let weaponNameY: CGFloat = weaponInfoBaseY
        weaponName.draw(at: CGPoint(x: weaponNameX, y: weaponNameY), withAttributes: [
            NSAttributedString.Key.font: weaponNameFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponStatusFont = UIFont(name: genshinUIFontName, size: 22)!
        let weaponStatusIconWidth: CGFloat = 22
        let weaponStatusIconHeight: CGFloat = 22
        
        let weaponLevelString = NSString(string: "Lv.\(character.weapon.level)")
        let weaponLevelX: CGFloat = weaponNameX
        let weaponLevelY: CGFloat = weaponNameY + weaponNameFont.pointSize + 16
        weaponLevelString.draw(at: CGPoint(x: weaponLevelX, y: weaponLevelY), withAttributes: [
            NSAttributedString.Key.font: weaponStatusFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponMainStatusIcon = UIImage(named: "PropIcon/\(character.weapon.mainAttribute.propIconString)")!
        let weaponMainStatusIconX: CGFloat = weaponLevelX + weaponStatusFont.pointSize / 2
        let weaponMainStatusIconY: CGFloat = weaponLevelY + weaponStatusFont.pointSize + 20
        weaponMainStatusIcon.draw(in: CGRect(x: weaponMainStatusIconX, y: weaponMainStatusIconY, width: weaponStatusIconWidth, height: weaponStatusIconHeight))
        
        let weaponMainStatusName = NSString(string: character.weapon.mainAttribute.name)
        let weaponMainStatusNameX: CGFloat = weaponMainStatusIconX + weaponStatusIconWidth
        let weaponMainStatusNameY: CGFloat = weaponMainStatusIconY
        weaponMainStatusName.draw(at: CGPoint(x: weaponMainStatusNameX, y: weaponMainStatusNameY), withAttributes: [
            NSAttributedString.Key.font: weaponStatusFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponMainStatusValue = NSString(string: character.weapon.mainAttribute.valueString)
        let weaponMainStatusValueX: CGFloat = weaponMainStatusNameX + (CGFloat(weaponMainStatusName.length) + 0.5) * weaponStatusFont.pointSize
        let weaponMainStatusValueY: CGFloat = weaponMainStatusNameY
        weaponMainStatusValue.draw(at: CGPoint(x: weaponMainStatusValueX, y: weaponMainStatusValueY), withAttributes: [
            NSAttributedString.Key.font: weaponStatusFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        if let weaponSubStatus = character.weapon.subAttribute {
            let weaponSubStatusIcon = UIImage(named: "PropIcon/\(weaponSubStatus.propIconString)")!
            let weaponSubStatusIconX: CGFloat = weaponMainStatusIconX
            let weaponSubStatusIconY: CGFloat = weaponMainStatusIconY + weaponStatusIconHeight + 16
            weaponSubStatusIcon.draw(in: CGRect(x: weaponSubStatusIconX, y: weaponSubStatusIconY, width: weaponStatusIconWidth, height: weaponStatusIconHeight))
            
            let weaponSubStatusNameX = weaponSubStatusIconX + weaponStatusIconWidth
            let weaponSubStatusNameY = weaponSubStatusIconY
            let weaponSubStatusName = NSString(string: weaponSubStatus.name)
            weaponSubStatusName.draw(at: CGPoint(x: weaponSubStatusNameX, y: weaponSubStatusNameY), withAttributes: [
                NSAttributedString.Key.font: weaponStatusFont,
                NSAttributedString.Key.foregroundColor: UIColor.white])
            
            let weaponSubStatusValue = NSString(string: weaponSubStatus.valueString)
            let weaponSubStatusValueX: CGFloat = weaponSubStatusNameX + (CGFloat(weaponSubStatusName.length) + 0.5) * weaponStatusFont.pointSize
            let weaponSubStatusValueY: CGFloat = weaponSubStatusNameY
            weaponSubStatusValue.draw(at: CGPoint(x: weaponSubStatusValueX, y: weaponSubStatusValueY), withAttributes: [
                NSAttributedString.Key.font: weaponStatusFont,
                NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        
        let skillIconBack = UIImage(named: "BuildCard/TalentBack")!
        let skillIconBackWidth: CGFloat = 128
        let skillIconBackHeight: CGFloat = 128
        let skillIconWidth: CGFloat = 76
        let skillIconHeight: CGFloat = 76
        for (index, skillIcon) in skillIcons.enumerated() {
            let skillIconBackRectX: CGFloat = 12
            let skillIconBackRectY: CGFloat = 276 + (skillIconBackHeight - 12) * CGFloat(index)
            let skillIconBackRect = CGRect(x: skillIconBackRectX, y: skillIconBackRectY, width: skillIconBackWidth, height: skillIconBackHeight)
            skillIconBack.draw(in: skillIconBackRect, blendMode: .sourceAtop, alpha: 0.8)
            
            let skillIconRectX: CGFloat = 38
            let skillIconRectY: CGFloat = 302 + (40 + skillIconHeight) * CGFloat(index)
            let skillIconRect = CGRect(x: skillIconRectX, y: skillIconRectY, width: skillIconWidth, height: skillIconHeight)
            skillIcon.draw(in: skillIconRect, blendMode: .sourceAtop, alpha: 1)
            
            let skillLevelX = skillIconRectX + 8
            let skillLevelY = skillIconRectY + skillIconHeight - 6
            let skillLevelString = NSString(string: "Lv.\(character.skills[index].levelAdjusted)")
            let skillLevelFont = UIFont(name: genshinUIFontName, size: 24)!
            if character.skills[index].level != character.skills[index].levelAdjusted {
                skillLevelString.draw(at: CGPoint(x: skillLevelX, y: skillLevelY), withAttributes: [
                    NSAttributedString.Key.font: skillLevelFont,
                    NSAttributedString.Key.foregroundColor: UIColor.cyan])
            } else {
                skillLevelString.draw(at: CGPoint(x: skillLevelX, y: skillLevelY), withAttributes: [
                    NSAttributedString.Key.font: skillLevelFont,
                    NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        
        let constellationIconBack = UIImage(named: "BuildCard/ConstellationIcon/\(character.element.rawValue)")!
        let lockedConstellationIcon = UIImage(named: "BuildCard/ConstellationIcon/\(character.element.rawValue)Lock")!
        let constellationIconBackWidth: CGFloat = 96
        let constellationIconBackHeight: CGFloat = 96
        let constellationIconWidth: CGFloat = 50
        let constellationIconHeight: CGFloat = 50
        for index in 0..<character.constellationStrings.count {
            let constellationIconBackRectX: CGFloat = 660
            let constellationIconBackReckY: CGFloat = 120 + (constellationIconBackHeight - 12) * CGFloat(index)
            let constellationIconBackRect = CGRect(x: constellationIconBackRectX, y: constellationIconBackReckY, width: constellationIconBackWidth, height: constellationIconBackHeight)
            
            if index < constellationIcons.count {
                constellationIconBack.draw(in: constellationIconBackRect, blendMode: .sourceAtop, alpha: 1)
                
                let constellationIconRectX: CGFloat = 681
                let constellationIconRectY: CGFloat = 142 + (34 + constellationIconHeight) * CGFloat(index)
                let constellationIconRect = CGRect(x: constellationIconRectX, y: constellationIconRectY, width: constellationIconWidth, height: constellationIconHeight)
                constellationIcons[index].draw(in: constellationIconRect, blendMode: .sourceAtop, alpha: 1)
            } else {
                lockedConstellationIcon.draw(in: constellationIconBackRect, blendMode: .sourceAtop, alpha: 1)
            }
        }
        
        let characterStatusBaseX: CGFloat = 1360
        let characterStatusBaseY: CGFloat = 64
        let characterStatusFont = UIFont(name: genshinUIFontName, size: 28)!
        for index in 0..<8 {
            let characterStatusString = NSString(string: character.basicFightPropString(index: index))
            let textSize = characterStatusString.size(withAttributes: [NSAttributedString.Key.font: characterStatusFont])
            let characterStatusX = characterStatusBaseX - textSize.width
            let characterStatusY = characterStatusBaseY + (textSize.height + 37) * CGFloat(index)
            characterStatusString.draw(at: CGPoint(x: characterStatusX, y: characterStatusY), withAttributes: [
                NSAttributedString.Key.font: characterStatusFont,
                NSAttributedString.Key.foregroundColor: UIColor.white])
            
            if index == 7 {
                let elementDamageIcon = UIImage(named: "ElementIcon/\(character.element.rawValue)")!
                let elementDamageIconX: CGFloat = 786
                let elementDamageIconY: CGFloat = characterStatusY - 6
                let elementDamageIconWidth: CGFloat = 44
                let elementDamageIconHeight: CGFloat = 44
                elementDamageIcon.draw(in: CGRect(x: elementDamageIconX, y: elementDamageIconY, width: elementDamageIconWidth, height: elementDamageIconHeight))
                
                let elementDamageString = NSString(string: "\(character.element.jpName)ダメージ")
                let elementDamageStringX = elementDamageIconX + elementDamageIconWidth + characterStatusFont.pointSize / 2
                let elementDamageStringY = characterStatusY
                elementDamageString.draw(at: CGPoint(x: elementDamageStringX, y: elementDamageStringY), withAttributes: [
                    NSAttributedString.Key.font: characterStatusFont,
                    NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        
        let artifactImageWidth: CGFloat = 248
        let artifactImageHeight: CGFloat = 248
        var equipedArtifactIndex = 0
        let artifactMainStatusValueFont = UIFont(name: genshinUIFontName, size: 50)!
        let artifactStatusNameFont = UIFont(name: genshinUIFontName, size: 32)!
        let artifactSubStatusFont = UIFont(name: genshinUIFontName, size: 24)!
        let artifactLevelFont = UIFont(name: genshinUIFontName, size: 24)!
        let artifactMainStatusIconWidth: CGFloat = 44
        let artifactMainStatusIconHeight: CGFloat = 44
        let artifactSubStatusIconWidth: CGFloat = 32
        let artifactSubStatusIconHeight: CGFloat = 32
        let artifactScoreString = UIFont(name: genshinUIFontName, size: 36)
        for (index, artifactImage) in artifactImages.enumerated() {
            if let artifactImage = artifactImage {
                let rectX: CGFloat = 28 + (124 + artifactImageWidth) * CGFloat(index)
                let rectY: CGFloat = 640
                artifactImage.draw(in: CGRect(x: rectX, y: rectY, width: artifactImageWidth, height: artifactImageHeight), blendMode: .sourceAtop, alpha: 0.7)
                
                let artifact = character.artifacts[equipedArtifactIndex]
                let statusX: CGFloat = 372 + CGFloat(373 * index)
                let statusY: CGFloat = 658
                
                let mainStatusName = NSString(string: artifact.mainAttribute.name)
                let mainStatusTextSize = mainStatusName.size(withAttributes: [NSAttributedString.Key.font: artifactStatusNameFont])
                let mainStatusNameX = statusX - mainStatusTextSize.width
                let mainStatusNameY = statusY + 4
                mainStatusName.draw(at: CGPoint(x: mainStatusNameX, y: mainStatusNameY), withAttributes: [
                    NSAttributedString.Key.font: artifactStatusNameFont,
                    NSAttributedString.Key.foregroundColor: UIColor.white])
                
                let mainStatusIcon = UIImage(named: "PropIcon/\(artifact.mainAttribute.propIconString)")!
                let mainStatusIconX: CGFloat = mainStatusNameX - artifactMainStatusIconWidth
                mainStatusIcon.draw(in: CGRect(x: mainStatusIconX, y: statusY, width: artifactMainStatusIconWidth, height: artifactMainStatusIconHeight))
                
                let mainStatusValueString = NSString(string: artifact.mainAttribute.valueString)
                let mainStatusValueTextSize = mainStatusValueString.size(withAttributes: [NSAttributedString.Key.font: artifactMainStatusValueFont])
                let mainStatusValueStringX = statusX - mainStatusValueTextSize.width
                let mainStatusValueStringY = statusY + mainStatusTextSize.height + 4
                mainStatusValueString.draw(at: CGPoint(x: mainStatusValueStringX, y: mainStatusValueStringY), withAttributes: [
                    NSAttributedString.Key.font: artifactMainStatusValueFont,
                    NSAttributedString.Key.foregroundColor: UIColor.white])
                
                let levelString = NSString(string: "+\(artifact.level)")
                let levelTextSize = levelString.size(withAttributes: [NSAttributedString.Key.font: artifactLevelFont])
                let levelStringX = statusX - levelTextSize.width
                let levelStringY = mainStatusValueStringY + mainStatusValueTextSize.height
                levelString.draw(at: CGPoint(x: levelStringX, y: levelStringY), withAttributes: [
                    NSAttributedString.Key.font: artifactLevelFont,
                    NSAttributedString.Key.foregroundColor: UIColor.white])
                
                let subStatusIconX: CGFloat = 44 + CGFloat(373 * index)
                var subStatusIconY: CGFloat = levelStringY + levelTextSize.height + 40
                for subStatus in artifact.subAttributes {
                    let icon = UIImage(named: "PropIcon/\(subStatus.propIconString)")!
                    icon.draw(in: CGRect(x: subStatusIconX, y: subStatusIconY, width: artifactSubStatusIconWidth, height: artifactSubStatusIconHeight))
                    
                    let name = NSString(string: subStatus.name)
                    let nameTextSize = name.size(withAttributes: [NSAttributedString.Key.font: artifactSubStatusFont])
                    let nameX = subStatusIconX + artifactMainStatusIconWidth
                    let nameY = subStatusIconY + 2
                    name.draw(at: CGPoint(x: nameX, y: nameY), withAttributes: [
                        NSAttributedString.Key.font: artifactSubStatusFont,
                        NSAttributedString.Key.foregroundColor: UIColor.white])
                    
                    let valueString = NSString(string: subStatus.valueString)
                    let valueStringTextSize = valueString.size(withAttributes: [NSAttributedString.Key.font: artifactSubStatusFont])
                    let valueX = statusX - valueStringTextSize.width
                    let valueY = nameY
                    valueString.draw(at: CGPoint(x: valueX, y: valueY), withAttributes: [
                        NSAttributedString.Key.font: artifactSubStatusFont,
                        NSAttributedString.Key.foregroundColor: UIColor.white])
                    
                    subStatusIconY += nameTextSize.height + 16
                }
                
                equipedArtifactIndex += 1
            }
        }
        
        let buildCardImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return buildCardImage!
    }
}
