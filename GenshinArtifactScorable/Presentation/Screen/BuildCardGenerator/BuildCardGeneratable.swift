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
        
        let weaponImageWidth: CGFloat = 153
        let weaponImageHeight: CGFloat = 153
        weaponImage.draw(in: CGRect(x: 1418, y: 32, width: weaponImageWidth, height: weaponImageHeight))
        
        let weaponRealityIcon = UIImage(named: "BuildCard/WeaponRealityIcon/\(character.weapon.rankLevel.rawValue).png")!
        let weaponRealityIconWidth: CGFloat = 153
        let weaponRealityIconHeight: CGFloat = 33
        weaponRealityIcon.draw(in: CGRect(x: 1418, y: 172, width: weaponRealityIconWidth, height: weaponRealityIconHeight))
        
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
        
        let characterNameFont = UIFont(name: "SDK_JP_Web", size: 48)!
        let characterName = NSString(string: character.name)
        characterName.draw(at: CGPoint(x: 32, y: 32), withAttributes: [
            NSAttributedString.Key.font: characterNameFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let characterLevelFont = UIFont(name: "SDK_JP_Web", size: 28)!
        let characterLevelString = NSString(string: String("Lv.\(character.level)"))
        characterLevelString.draw(at: CGPoint(x: 32, y: 84), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let friendshipIcon = UIImage(named: "BuildCard/Friendship.png")!
        let friendshipIconWidth: CGFloat = 39
        let friendshipIconHeight: CGFloat = 32
        friendshipIcon.draw(in: CGRect(x: 116, y: 84, width: friendshipIconWidth, height: friendshipIconHeight))
        
        let friendshipLevel = NSString(string: String(character.friendshipLevel))
        friendshipLevel.draw(at: CGPoint(x: 152, y: 84), withAttributes: [
            NSAttributedString.Key.font: characterLevelFont,
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let buildCardImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return buildCardImage!
    }
}
