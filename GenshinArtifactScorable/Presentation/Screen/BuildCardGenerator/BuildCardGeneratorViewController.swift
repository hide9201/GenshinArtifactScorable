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
    private var buildCardGenerator: BuildCardGenerator!
    
    private var buildCardBaseImage: UIImage?
    private var characterImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "スコア：\(String(format: "%.1f", character.calculateTotalScore(criteria: scoreCriteria)))"
    }
    
    // MARK: - Private
    
    private func prepareUIImages() {
        buildCardBaseImage = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")
        imageService.fetchUIImage(imageString: character.imageString)
            .done { characterImage in
                self.characterImage = characterImage
                self.generateBuildCardIfPrepared()
            }.catch { error in
                print(error)
            }
    }
    
    private func generateBuildCardIfPrepared() {
        
        // 全ての画像が用意できたら生成する(聖遺物をつけていない場合，聖遺物の画像がnilになるので今のままだとヤバい)
        // 全ての画像についてAPIを叩き終えたかをどう管理するべき？
        // ビルドカード作成をAPIが叩き終わるごとに毎回呼ぶ？その場合，ビルドカード生成コードの引数を(現状で完成しているまでのビルドカード, 新しく追加する画像, 追加する画像のパーツ名(新しく追加する画像をどこに配置するかを判断するため，enumとかで管理する))とかにする．ビルドカード生成中に他のAPIが完了して再度呼ばれるとやばそう
        if let buildCardBaseImage = buildCardBaseImage, let characterImage = characterImage {
            buildCardImageView.image = buildCardGenerator.buildCardCreate(buildCardBaseImage: buildCardBaseImage, characterImage: characterImage)
        }
    }
}

extension BuildCardGeneratorViewController: Storyboardable {
    func inject(_ dependency: (character: Character, scoreCriteria: ScoreCriteria)) {
        self.character = dependency.character
        self.scoreCriteria = dependency.scoreCriteria
        self.imageService = ImageService()
        self.buildCardGenerator = BuildCardGenerator()
        prepareUIImages()
    }
}
