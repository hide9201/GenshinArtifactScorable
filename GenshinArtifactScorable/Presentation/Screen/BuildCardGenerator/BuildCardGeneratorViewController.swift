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
    
    private var loadingView = LoadingView(with: ())
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIImages()
    }
    
    // MARK: - Private
    
    private func showLoadingView() {
        loadingView.frame = view.frame
        view.addSubview(loadingView)
        loadingView.startLoading()
    }
    
    private func hideLoadingView() {
        loadingView.stopLoading()
        loadingView.removeFromSuperview()
    }
    
    private func prepareUIImages() {
        showLoadingView()
        imageService.fetchUIImage(imageString: character.imageString)
            .done { characterImage in
                self.characterImage = characterImage
                self.generateBuildCardIfPrepared()
            }.catch { error in
                print(error)
            }
        
        imageService.fetchUIImage(imageString: character.weapon.iconString)
            .done { weaponImage in
                self.weaponImage = weaponImage
                self.generateBuildCardIfPrepared()
            }.catch { error in
                print(error)
            }
        
        for (index, skill) in character.skills.enumerated() {
            imageService.fetchUIImage(imageString: skill.iconString)
                .done { skillIcon in
                    self.skillIcons[index] = skillIcon
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                }
        }
        
        for index in 0..<constellationIcons.count {
            imageService.fetchUIImage(imageString: character.constellationStrings[index])
                .done { constellationIcon in
                    self.constellationIcons[index] = constellationIcon
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
                    self.generateBuildCardIfPrepared()
                }.catch { error in
                    print(error)
                }
        }
    }
    
    private func generateBuildCardIfPrepared() {
        guard let characterImage = characterImage, let weaponImage = weaponImage else { return }
        if isSkillIconsPrepared(), isArtifactsImagesPrepared(), isConstellationIconsPrepared() {
            buildCardImageView.image = generateBuildCard(character: character, scoreCalculateType: scoreCalculateType, characterImage: characterImage, weaponImage: weaponImage, skillIcons: skillIcons.map { $0! }, constellationIcons: constellationIcons.map { $0! }, artifactImages: artifactImages)
            hideLoadingView()
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
