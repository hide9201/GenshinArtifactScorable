//
//  SearchHistoryTableViewCell.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/06/04.
//

import UIKit
import ReusableKit

final class SearchHistoryTableViewCell: UITableViewCell {
    static let reusable = ReusableCell<SearchHistoryTableViewCell>(nibName: "SearchHistoryTableViewCell")
    
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
}

extension SearchHistoryTableViewCell: NibInstantiatable {
    func inject(_ dependency: ShapedAccountAllInfo) {
        let imageService = ImageService()
        
        imageService.fetchUIImage(imageString: dependency.playerBasicInfo.profilePictureCharacterIconString)
            .done { profileIcon in
                self.profileIconImageView.image = profileIcon
                self.userNameLabel.text = dependency.playerBasicInfo.playerName
                self.uidLabel.text = dependency.uid
            }.catch { error in
                print(error)
            }
    }
}
