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
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .lightGray : .clear
        }
    }
    
    @IBOutlet weak var characterBackgroundImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var elementIconView: UIImageView!
    @IBOutlet weak var characterLevelLabel: UILabel!
}

extension CharacterCollectionViewCell: NibInstantiatable {
    func inject(_ dependency: (character: ShapedAccountAllInfo.ScorableCharacter, imageService: ImageService)) {
        dependency.imageService.fetchUIImage(imageName: "\(dependency.character.iconString)")
            .done { image in
                self.characterImageView.image = image
            }.catch { error in
                print(error)
            }
        characterLevelLabel.text = "Lv.\(dependency.character.level)"
        characterBackgroundImageView.image = UIImage(named: dependency.character.quality.characterBackgroundIconString)
        elementIconView.image = UIImage(named: "ElementIcon/\(dependency.character.element)")
    }
}
