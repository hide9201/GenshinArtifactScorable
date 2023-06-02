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
        
        let genshinUIFont = "SDK_JP_Web"
        
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
        
        let characterNameFont = UIFont(name: genshinUIFont, size: 48)!
        let characterName = NSString(string: character.name)
        let characterNameX: CGFloat = 32
        let characterNameY: CGFloat = 32
        characterName.draw(at: CGPoint(x: characterNameX, y: characterNameY), withAttributes: [
            NSAttributedString.Key.font: characterNameFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let characterLevelFont = UIFont(name: genshinUIFont, size: 28)!
        let characterLevelString = NSString(string: String("Lv.\(character.level)"))
        let characterLevelX: CGFloat = characterNameX
        let characterLevelY: CGFloat = characterNameY + characterNameFont.pointSize + 4
        characterLevelString.draw(at: CGPoint(x: characterLevelX, y: characterLevelY), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let friendshipIcon = UIImage(named: "BuildCard/Friendship.png")!
        let friendshipIconX: CGFloat = characterLevelX + CGFloat(characterLevelString.length - 2) * characterLevelFont.pointSize
        let friendshipIconY: CGFloat = characterLevelY
        let friendshipIconWidth: CGFloat = 34
        let friendshipIconHeight: CGFloat = 28
        friendshipIcon.draw(in: CGRect(x: friendshipIconX, y: friendshipIconY, width: friendshipIconWidth, height: friendshipIconHeight))
        
        let friendshipLevel = NSString(string: String(character.friendshipLevel))
        let friendshipLevelX: CGFloat = friendshipIconX + friendshipIconWidth
        let friendshipLevelY: CGFloat = friendshipIconY
        friendshipLevel.draw(at: CGPoint(x: friendshipLevelX, y: friendshipLevelY), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponInfoBaseX: CGFloat = 1436
        let weaponInfoBaseY: CGFloat = 44
        let weaponImageWidth: CGFloat = 128
        let weaponImageHeight: CGFloat = 128
        weaponImage.draw(in: CGRect(x: weaponInfoBaseX, y: weaponInfoBaseY, width: weaponImageWidth, height: weaponImageHeight)) // 1418, 32
        
        let weaponRealityIcon = UIImage(named: "BuildCard/WeaponRealityIcon/\(character.weapon.rankLevel.rawValue).png")!
        let weaponRealityIconWidth: CGFloat = 153
        let weaponRealityIconHeight: CGFloat = 33
        weaponRealityIcon.draw(in: CGRect(x: weaponInfoBaseX - 16, y: weaponInfoBaseY + weaponImageHeight, width: weaponRealityIconWidth, height: weaponRealityIconHeight))
        
        let weaponRefinementRankFont = UIFont(name: genshinUIFont, size: 26)!
        let weaponRefinementRankString = NSString(string: "R\(character.weapon.refinementRank)")
        let weaponRefinementRankX: CGFloat = weaponInfoBaseX
        let weaponRefinementRankY: CGFloat = weaponInfoBaseY
        weaponRefinementRankString.draw(at: CGPoint(x: weaponRefinementRankX, y: weaponRefinementRankY), withAttributes: [
            NSAttributedString.Key.font: weaponRefinementRankFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponNameFont = UIFont(name: genshinUIFont, size: 26)!
        let weaponName = NSString(string: character.weapon.name)
        let weaponNameX: CGFloat = weaponInfoBaseX + weaponImageWidth + 16
        let weaponNameY: CGFloat = weaponInfoBaseY
        weaponName.draw(at: CGPoint(x: weaponNameX, y: weaponNameY), withAttributes: [
            NSAttributedString.Key.font: weaponNameFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponStatusFont = UIFont(name: genshinUIFont, size: 22)!
        let weaponStatusIconWidth: CGFloat = 22
        let weaponStatusIconHeight: CGFloat = 22
        
        let weaponLevelString = NSString(string: "Lv.\(character.weapon.level)")
        let weaponLevelX: CGFloat = weaponNameX
        let weaponLevelY: CGFloat = weaponNameY + weaponNameFont.pointSize + 16
        weaponLevelString.draw(at: CGPoint(x: weaponLevelX, y: weaponLevelY), withAttributes: [
            NSAttributedString.Key.font: weaponStatusFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let weaponMainStatusIcon = UIImage(named: "PropIcon/\(character.weapon.mainAttribute.propIconString).png")!
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
            print(weaponSubStatus)
            let weaponSubStatusIcon = UIImage(named: "PropIcon/\(weaponSubStatus.propIconString).png")!
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
        
        
        let skillIconBack = UIImage(named: "BuildCard/TalentBack.png")!
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
        
        let artifactImageWidth: CGFloat = 248
        let artifactImageHeight: CGFloat = 248
        for (index, artifactImage) in artifactImages.enumerated() {
            if let artifactImage = artifactImage {
                let rectX: CGFloat = 28 + (124 + artifactImageWidth) * CGFloat(index)
                let rectY: CGFloat = 640
                let rect = CGRect(x: rectX, y: rectY, width: artifactImageWidth, height: artifactImageHeight)
                artifactImage.draw(in: rect, blendMode: .sourceAtop, alpha: 0.7)
            }
        }
        
        let buildCardImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return buildCardImage!
    }
}
