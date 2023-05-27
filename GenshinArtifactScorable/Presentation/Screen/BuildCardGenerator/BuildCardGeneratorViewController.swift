//
//  BuildCardGeneratorViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/27.
//

import UIKit

final class BuildCardGeneratorViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var buildCardImageView: UIImageView! {
        didSet {
            buildCardImageView.image = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")
        }
    }
    
    // MARK: - Property
    
    private var character: Character!
    private var scoreCriteria: ScoreCriteria!
    private var imageService: ImageService!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "スコア：\(String(format: "%.1f", character.calculateTotalScore(criteria: scoreCriteria)))"
    }
    
    // MARK: - Private
    
}

extension BuildCardGeneratorViewController: Storyboardable {
    func inject(_ dependency: (character: Character, scoreCriteria: ScoreCriteria)) {
        self.character = dependency.character
        self.scoreCriteria = dependency.scoreCriteria
        self.imageService = ImageService()
    }
}
