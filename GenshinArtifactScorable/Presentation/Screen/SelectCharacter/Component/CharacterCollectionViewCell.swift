//
//  CharacterCollectionViewCell.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/29.
//

import UIKit
import ReusableKit
import Instantiate

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let reusable = ReusableCell<CharacterCollectionViewCell>(nibName: "CharacterCollectionViewCell")
    
    @IBOutlet weak var characterBackgroundImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterLevelLabel: UILabel!
}

extension CharacterCollectionViewCell: NibInstantiatable {
    func inject(_ dependency: (avatarInfo: AvatarInfo, appResource: AppResource)) {
        if let characterNameFromAvatarIdJSON = dependency.appResource.characterNameFromAvatarIdJSON {
            var characterName = characterNameFromAvatarIdJSON[String(dependency.avatarInfo.avatarId)]["characterNameEN"].stringValue
            
            if characterName == "Lumine" || characterName == "Aether" {
                characterName += "(None)"
            }
            characterImageView.image = UIImage(named: "characters/\(characterName)/icon")
        }
        if let characterLevelText = dependency.avatarInfo.propMap["4001"]?.val {
            characterLevelLabel.text = "Lv. \(characterLevelText)"
        }
    }
}
