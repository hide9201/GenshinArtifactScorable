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
    private var buildCardBaseImage: UIImage!
    
    private var characterImage: UIImage?
    private var weaponImage: UIImage?

    private var artifactImages = [UIImage?](repeating: nil, count: 5)
    
    private var isArtifactImageFetchedArray = [Bool](repeating: false, count: 5)
    private var isArtifactEquipedArray = [Bool](repeating: false, count: 5)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "スコア：\(String(format: "%.1f", character.calculateTotalScore(criteria: scoreCriteria)))"
        prepareUIImages()
    }
    
    // MARK: - Private
    
    private func prepareUIImages() {
        imageService.fetchUIImage(imageString: character.imageString)
            .done { characterImage in
                self.characterImage = characterImage
                self.imageService.saveUIImage(image: characterImage, imageString: self.character.imageString)
                self.generateBuildCardIfPrepared()
            }.catch { error in
                print(error)
            }
        
        imageService.fetchUIImage(imageString: character.weapon.iconString)
            .done { weaponImage in
                self.weaponImage = weaponImage
                self.imageService.saveUIImage(image: weaponImage, imageString: self.character.weapon.iconString)
                self.generateBuildCardIfPrepared()
            }.catch { error in
                print(error)
            }
    
        character.artifacts.forEach { artifact in
            imageService.fetchUIImage(imageString: artifact.iconString)
                .done { artifactImage in
                    switch artifact.artifactType {
                    case .flower:
                        self.artifactImages[0] = artifactImage
                        self.isArtifactImageFetchedArray[0] = true
                    case .plume:
                        self.artifactImages[1] = artifactImage
                        self.isArtifactImageFetchedArray[1] = true
                    case .sands:
                        self.artifactImages[2] = artifactImage
                        self.isArtifactImageFetchedArray[2] = true
                    case .goblet:
                        self.artifactImages[3] = artifactImage
                        self.isArtifactImageFetchedArray[3] = true
                    case .circlet:
                        self.artifactImages[4] = artifactImage
                        self.isArtifactImageFetchedArray[4] = true
                    }
                    self.imageService.saveUIImage(image: artifactImage, imageString: artifact.iconString)
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                    
                    switch artifact.artifactType {
                    case .flower:
                        self.isArtifactImageFetchedArray[0] = true
                    case .plume:
                        self.isArtifactImageFetchedArray[1] = true
                    case .sands:
                        self.isArtifactImageFetchedArray[2] = true
                    case .goblet:
                        self.isArtifactImageFetchedArray[3] = true
                    case .circlet:
                        self.isArtifactImageFetchedArray[4] = true
                    }
                    self.generateBuildCardIfPrepared()
                }
        }
    }
    
    private func generateBuildCardIfPrepared() {
        guard let characterImage = characterImage, let weaponImage = weaponImage else { return }
        
        // 全ての画像が用意できたら生成する(聖遺物をつけていない場合，聖遺物の画像がnilになるので今のままだとヤバい)
        // 全ての画像についてAPIを叩き終えたかをどう管理するべき？
        // ビルドカード作成をAPIが叩き終わるごとに毎回呼ぶ？その場合，ビルドカード生成コードの引数を(現状で完成しているまでのビルドカード, 新しく追加する画像, 追加する画像のパーツ名(新しく追加する画像をどこに配置するかを判断するため，enumとかで管理する))とかにする．ビルドカード生成中に他のAPIが完了して再度呼ばれるとやばそう
        if isArtifactsImagesPrepared() {
            buildCardImageView.image = buildCardGenerator.buildCardCreate(buildCardBaseImage: buildCardBaseImage, characterImage: characterImage, weaponImage: weaponImage, artifactImages: artifactImages)
        }
    }
    
    private func isArtifactsImagesPrepared() -> Bool {
        var isPrepared = true
        // 装備しているにも関わらず，画像取得の通信が終わってない場合，ビルドカードの準備ができてない
        for (i, value) in isArtifactImageFetchedArray.enumerated() {
            if !value, isArtifactEquipedArray[i] {
                isPrepared = false
            }
        }
        return isPrepared
    }
}

extension BuildCardGeneratorViewController: Storyboardable {
    func inject(_ dependency: (character: Character, scoreCriteria: ScoreCriteria)) {
        self.character = dependency.character
        self.scoreCriteria = dependency.scoreCriteria
        self.imageService = ImageService()
        self.buildCardGenerator = BuildCardGenerator()
        self.buildCardBaseImage = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")
        
        character.artifacts.forEach { artifact in
            switch artifact.artifactType {
            case .flower:
                self.isArtifactEquipedArray[0] = true
            case .plume:
                self.isArtifactEquipedArray[1] = true
            case .sands:
                self.isArtifactEquipedArray[2] = true
            case .goblet:
                self.isArtifactEquipedArray[3] = true
            case .circlet:
                self.isArtifactEquipedArray[4] = true
            }
        }
    }
}
