//
//  ImageCachesManager.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/05/23.
//

import UIKit
import Foundation

final class ImageCachesManager {
    
    private let fileManager: FileManager
    
    init() {
        fileManager = FileManager.default
    }
    
    func getFileURL(imageString: String) -> URL {
        let documentDirectoryFileURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentDirectoryFileURL.appendingPathComponent("\(imageString).png")
    }
    
    func saveUIImage(image: UIImage, imageString: String) throws {
        let fileURL = getFileURL(imageString: imageString)
        if fileManager.fileExists(atPath: fileURL.path) {
            return
        }
        
        guard let imageData = image.pngData() else { return }
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            throw ImageCachesManagerError.write(error)
        }
    }
    
    func getUIImage(imageString: String) -> UIImage? {
        let path = getFileURL(imageString: imageString).path
        
        return UIImage(contentsOfFile: path)
    }
}
