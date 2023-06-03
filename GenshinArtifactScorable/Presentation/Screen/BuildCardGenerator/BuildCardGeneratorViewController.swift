//
//  BuildCardGeneratorViewController.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/27.
//

import UIKit

final class BuildCardGeneratorViewController: UIViewController, BuildCardGeneratable {
    
    // MARK: - Outlet
    
    @IBOutlet weak var buildCardImageView: UIImageView! {
        didSet {
            buildCardImageView.image = UIImage(named: "BuildCard/Base/\(character.element.rawValue)")
        }
    }
    
    // MARK: - Property
    
    private var character: Character!
    private var scoreCalculateType: ScoreCalculateType!
    private var imageService: ImageService!
    
    private var characterImage: UIImage?
    private var weaponImage: UIImage?
    private var skillIcons: [UIImage?]!
    private var constellationIcons: [UIImage?]!
    private var artifactImages: [UIImage?]!
    
    private var isArtifactEquipedArray: [Bool]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        for (index, skill) in character.skills.enumerated() {
            imageService.fetchUIImage(imageString: skill.iconString)
                .done { skillIcon in
                    self.skillIcons[index] = skillIcon
                    self.imageService.saveUIImage(image: skillIcon, imageString: skill.iconString)
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                }
        }
        
        for index in 0..<constellationIcons.count {
            imageService.fetchUIImage(imageString: character.constellationStrings[index])
                .done { constellationIcon in
                    self.constellationIcons[index] = constellationIcon
                    self.imageService.saveUIImage(image: constellationIcon, imageString: self.character.constellationStrings[index])
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                }
        }
    
        // character.artifactsは長さが不定(1〜5の間)なので，artifactImagesはenumeratedによるインデックスアクセス不可
        // forEachにより，装備している各聖遺物タイプに応じたインデックスアクセスとする
        character.artifacts.forEach { artifact in
            imageService.fetchUIImage(imageString: artifact.iconString)
                .done { artifactImage in
                    switch artifact.artifactType {
                    case .flower:
                        self.artifactImages[0] = artifactImage
                    case .plume:
                        self.artifactImages[1] = artifactImage
                    case .sands:
                        self.artifactImages[2] = artifactImage
                    case .goblet:
                        self.artifactImages[3] = artifactImage
                    case .circlet:
                        self.artifactImages[4] = artifactImage
                    }
                    self.imageService.saveUIImage(image: artifactImage, imageString: artifact.iconString)
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                }
        }
    }
    
    private func generateBuildCardIfPrepared() {
        guard let characterImage = characterImage, let weaponImage = weaponImage else { return }
        
        // 全ての画像が用意できたら生成する(聖遺物をつけていない場合，聖遺物の画像がnilになるので今のままだとヤバい)
        // 全ての画像についてAPIを叩き終えたかをどう管理するべき？
        // ビルドカード作成をAPIが叩き終わるごとに毎回呼ぶ？その場合，ビルドカード生成コードの引数を(現状で完成しているまでのビルドカード, 新しく追加する画像, 追加する画像のパーツ名(新しく追加する画像をどこに配置するかを判断するため，enumとかで管理する))とかにする．ビルドカード生成中に他のAPIが完了して再度呼ばれるとやばそう
        if isSkillIconsPrepared(), isArtifactsImagesPrepared(), isConstellationIconsPrepared() {
            buildCardImageView.image = generateBuildCard(character: character, scoreCalculateType: scoreCalculateType, characterImage: characterImage, weaponImage: weaponImage, skillIcons: skillIcons.map { $0! }, constellationIcons: constellationIcons.map { $0! }, artifactImages: artifactImages)
        }
    }
    
    private func isSkillIconsPrepared() -> Bool {
        var isPrepared = true
        skillIcons.forEach {
            if $0 == nil { isPrepared = false }
        }
        return isPrepared
    }
    
    private func isConstellationIconsPrepared() -> Bool {
        var isPrepared = true
        constellationIcons.forEach {
            if $0 == nil { isPrepared = false }
        }
        return isPrepared
    }
    
    private func isArtifactsImagesPrepared() -> Bool {
        var isPrepared = true
        // 装備しているにも関わらず，画像取得の通信が終わってない場合，ビルドカードの準備ができてない
        for (index, artifactImage) in artifactImages.enumerated() {
            if artifactImage == nil, isArtifactEquipedArray[index] {
                isPrepared = false
            }
        }
        return isPrepared
    }
    
    @IBAction func CloseButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ShareButtonDidTap(_ sender: Any) {
        let shareImage = buildCardImageView.image!
        let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        
        var excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .copyToPasteboard,
            .mail,
            .markupAsPDF,
            .openInIBooks,
            .print,
            UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        
        if #available(iOS 16.0, *) {
            excludedActivityTypes.append(.collaborationCopyLink)
            excludedActivityTypes.append(.collaborationInviteWithLink)
        }
        
        if #available(iOS 16.4, *) {
            excludedActivityTypes.append(.addToHomeScreen)
        }
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        activityViewController.modalPresentationStyle = .pageSheet
        let navigation = UINavigationController(rootViewController: activityViewController)
        present(navigation, animated: true)
    }
}

extension BuildCardGeneratorViewController: Storyboardable {
    func inject(_ dependency: (character: Character, scoreCalculateType: ScoreCalculateType)) {
        self.character = dependency.character
        self.scoreCalculateType = dependency.scoreCalculateType
        
        self.imageService = ImageService()
    
        self.skillIcons = Array(repeating: nil, count: character.skills.count)
        self.constellationIcons = Array(repeating: nil, count: character.constellationLevel)
        self.artifactImages = Array(repeating: nil, count: 5)
        self.isArtifactEquipedArray = Array(repeating: false, count: 5)
        
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
