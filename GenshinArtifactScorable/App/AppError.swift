//
//  AppError.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import Foundation

enum APIError: Error {
    enum HTTPStatusCodeError: Error {
        
        /// 400
        case badRequest
        
        /// 404
        case notFound
        
        /// 424
        case failedDependency
        
        /// 429
        case tooManyRequests
        
        /// 500
        case internalServerError
        
        /// 503
        case serviceUnavailable
        
        /// 200番台(成功)以外で上記以外の番号
        case unknown(Int)
        
        var message: String {
            switch self {
            case .badRequest:
                return "UIDのフォーマットが不正です．UIDを確認の上，再入力してください．"
            case .notFound:
                return "UIDに対応するユーザが存在しません．UIDを確認の上，再入力してください．"
            case .failedDependency:
                return "ゲームのメンテナンス中です．メンテナンス終了後に再度お試しください．"
            case .tooManyRequests:
                return "API呼び出しの回数制限を超えました．時間をおいて再度お試しください．"
            case .internalServerError:
                return "EnkaNetworkサーバでエラーが発生しました．繰り返し発生する場合はお問い合わせください．"
            case .serviceUnavailable:
                return "サーバが一時停止中です．時間をおいて再度お試しください．"
            case .unknown(_):
                return "不明なエラーが発生しました．繰り返し発生する場合はお問い合わせください．"
            }
        }
        
        // MARK: - Initializer
        
        init(statusCode: Int) {
            switch statusCode {
            case 400:
                self = .badRequest
            case 404:
                self = .notFound
            case 424:
                self = .failedDependency
            case 429:
                self = .tooManyRequests
            case 500:
                self = .internalServerError
            case 503:
                self = .serviceUnavailable
            default:
                self = .unknown(statusCode)
            }
        }
    }
    
    /// 200番台以外のステータスコードが返ってきた
    case statusCode(HTTPStatusCodeError)
    
    /// レスポンスを受け取れなかった(ネットワーク不良など)
    case response(Error)
    
    /// レスポンスの変換に失敗した
    case convert(Error)
    
    /// 同一UIDに対して短時間に複数リクエストをした
    case refreshTooFast(dateWhenRefreshable: Date)
    
    var message: String {
        switch self {
        case .statusCode(let httpStatusCodeError):
            return httpStatusCodeError.message
        case .response(_):
            return "Wi-Fiまたはモバイル回線が有効になっていることを確認してください．"
        case .convert(_):
            return "再度お試しください．繰り返し発生する場合はお問い合わせください．"
        case .refreshTooFast(dateWhenRefreshable: let dateWhenRefreshable):
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
            formatter.locale = Locale(identifier: "ja-JP")
            return "同一UIDに対するリクエストの間隔が短すぎます．\(formatter.string(from: dateWhenRefreshable))以降に再度お試しください．\n現在キャッシュの情報を表示中です．"
        }
    }
    
}

enum AppResourceError: Error {
    case fileReadError
    var message: String {
        return "ファイルの読み込み・デコードに失敗しました．再度お試しください．"
    }
}

enum ImageCachesManagerError: Error {
    /// 書き込みに失敗した
    case write(Error)
    
    // キャッシュの失敗はユーザに通知の必要なし？なのでmessageプロパティはなし
}

enum DataStoreError: Error {

    /// トランザクションが失敗した
    case transaction(Error)

    /// 指定したオブジェクトが存在しない
    case notFound(String)
    
    // こっちのキャッシュは検索履歴とかに影響するので失敗時は通知する
    var message: String {
        return "再度お試しください．繰り返し発生する場合はお問い合わせください．"
    }
}
