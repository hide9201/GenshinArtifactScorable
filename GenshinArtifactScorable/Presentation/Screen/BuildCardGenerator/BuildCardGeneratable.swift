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
    
    func generateBuildCard(buildCardBaseImage: UIImage,
                         characterImage: UIImage,
                         weaponImage: UIImage,
                         skillIcons: [UIImage?],
                         artifactImages: [UIImage?]) -> UIImage {
        //画像の下地をサイズを指定して作成
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1920, height: 1080), false, 0)
        
        buildCardBaseImage.draw(in: CGRect(x: 0, y: 0, width: 1920, height: 1080))
        
        // characterImageMaxHeightはもうちょい小さくてもいいかも，画像の横がはみ出るようならcharacterImageMaxHeightを小さくしてみる
        let characterImageMaxWidth: CGFloat = 756
        let characterImageMaxHeight: CGFloat = 646
        let characterImageScale = characterImageMaxHeight / characterImage.size.height
        let characterImageWidth = characterImage.size.width * characterImageScale
        let characterImageHeight = characterImage.size.height * characterImageScale
        characterImage.draw(in: CGRect(x: (characterImageMaxWidth - characterImageWidth) / 2, y: (characterImageMaxHeight - characterImageHeight) / 2, width: characterImageWidth, height: characterImageHeight))
        
        let weaponImageMaxWidth: CGFloat = 152
        let weaponImageMaxHeight: CGFloat = 180
        let weaponImageScale = weaponImageMaxWidth / weaponImage.size.width
        let weaponImageWidth = weaponImage.size.width * weaponImageScale
        let weaponImageHeight = weaponImage.size.height * weaponImageScale
        weaponImage.draw(in: CGRect(x: 1418 + (weaponImageMaxWidth - weaponImageWidth) / 2, y: 32 + (weaponImageMaxHeight - weaponImageHeight) / 2, width: weaponImageWidth, height: weaponImageHeight))
        
        let skillIconBack = UIImage(named: "BuildCard/TalentBack.png")!
        let skillIconBackWidth: CGFloat = 128
        let skillIconBackHeight: CGFloat = 128
        let skillIconWidth: CGFloat = 76
        let skillIconHeight: CGFloat = 76
        for (index, skillIcon) in skillIcons.enumerated() {
            if let skillIcon = skillIcon {
                let skillIconBackRectX: CGFloat = 12
                let skillIconBackRectY: CGFloat = 276 + (skillIconBackHeight - 12) * CGFloat(index)
                let skillIconBackRect = CGRect(x: skillIconBackRectX, y: skillIconBackRectY, width: skillIconBackWidth, height: skillIconBackHeight)
                skillIconBack.draw(in: skillIconBackRect, blendMode: .sourceAtop, alpha: 1)
                
                let skillIconRectX: CGFloat = 38
                let skillIconRectY: CGFloat = 302 + (40 + skillIconHeight) * CGFloat(index)
                let skillIconRect = CGRect(x: skillIconRectX, y: skillIconRectY, width: skillIconWidth, height: skillIconHeight)
                skillIcon.draw(in: skillIconRect, blendMode: .sourceAtop, alpha: 1)
            }
        }
        
        
        let artifactImageWidth: CGFloat = 264
        let artifactImageHeight: CGFloat = 264
        for (index, artifactImage) in artifactImages.enumerated() {
            if let artifactImage = artifactImage {
                let rectX: CGFloat = 12 + (108 + artifactImageWidth) * CGFloat(index)
                let rectY: CGFloat = 632
                let rect = CGRect(x: rectX, y: rectY, width: artifactImageWidth, height: artifactImageHeight)
                artifactImage.draw(in: rect, blendMode: .sourceAtop, alpha: 0.8)
            }
        }
        
        let buildCardImage = UIGraphicsGetImageFromCurrentImageContext()

        //描画を終了
        UIGraphicsEndImageContext()
        return buildCardImage!
    }
}
