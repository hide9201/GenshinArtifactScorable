//
//  BuildCardGenerator.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/31.
//

import Foundation
import UIKit

struct BuildCardGenerator {
    
    func buildCardCreate(buildCardBaseImage: UIImage, characterImage: UIImage, weaponImage: UIImage, artifactImages: [UIImage?]) -> UIImage {
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
        
        for (i, artifactImage) in artifactImages.enumerated() {
            if let artifactImage = artifactImage {
                let artifactImageMaxWidth: CGFloat = 240
                let artifactImageMaxHeight: CGFloat = 240
                let artifactImageScale = min(artifactImageMaxWidth / artifactImage.size.width, artifactImageMaxHeight / artifactImageMaxHeight)
                let artifactImageWidth = artifactImage.size.width * artifactImageScale
                let artifactImageHeight = artifactImage.size.height * artifactImageScale
                let offset = CGFloat(30) + (CGFloat(190) + artifactImageWidth) * CGFloat(i)
                let rectX = offset + (artifactImageMaxWidth - artifactImageWidth) / 2
                let rectY = 624 + (artifactImageMaxHeight - artifactImageHeight) / 2
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
