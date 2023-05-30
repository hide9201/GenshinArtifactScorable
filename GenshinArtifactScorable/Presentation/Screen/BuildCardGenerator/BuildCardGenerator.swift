//
//  BuildCardGenerator.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/31.
//

import Foundation
import UIKit

struct BuildCardGenerator {
    
    func buildCardCreate(buildCardBaseImage: UIImage, characterImage: UIImage) -> UIImage {
        //画像の下地をサイズを指定して作成
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1920, height: 1080), false, 0)
        
        buildCardBaseImage.draw(in: CGRect(x: 0, y: 0, width: 1920, height: 1080))
        
        // characterImageMaxHeightはもうちょい小さくてもいいかも，画像の横がはみ出るようならcharacterImageMaxHeightを小さくしてみる
        let characterImageMaxWidth: CGFloat = 756
        let characterImageMaxHeight: CGFloat = 646
        let characterImageScale = characterImageMaxHeight / characterImage.size.height
        let characterImageWidth = characterImage.size.width * characterImageScale
        let characterImageHeight = characterImage.size.height * characterImageScale
        characterImage.draw(in: CGRect(x: (characterImageMaxWidth - characterImageWidth) / 2, y: (characterImageMaxHeight - characterImageHeight), width: characterImageWidth, height: characterImageHeight))

        let buildCardImage = UIGraphicsGetImageFromCurrentImageContext()

        //描画を終了
        UIGraphicsEndImageContext()
        return buildCardImage!
    }
}
