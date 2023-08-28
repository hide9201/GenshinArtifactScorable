//
//  ImageService.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import PromiseKit

struct ImageService {
    
    private let imageCachesManager: ImageCachesManager
    
    init() {
        imageCachesManager = ImageCachesManager()
    }
    
    func fetchUIImage(imageString: String) -> Promise<UIImage> {
        if let image = imageCachesManager.getUIImage(imageString: imageString) {
            return Promise { resolver in
                resolver.fulfill(image)
            }
        } else {
            return ImageAPI.shared.call(ImageTarget.fetchUIImage(imageString: imageString))
                .map { image in
                    saveUIImage(image: image, imageString: imageString)
                    return image
                }
        }
    }
    
    func saveUIImage(image: UIImage, imageString: String) {
        do {
            try imageCachesManager.saveUIImage(image: image, imageString: imageString)
        } catch {
            // キャッシュの失敗はユーザへの通知は必要ない？のでViewControllerにはthrowしない
            print(error)
        }
    }
}
