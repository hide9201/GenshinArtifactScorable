//
//  RealmManager.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/28.
//
import PromiseKit
import RealmSwift
import Foundation

final class DataStore {
    
    static let shared = DataStore()
    
    let realm: Realm
    
    private init() {
        let currentSchemaVersion: UInt64 = 4
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { migration, oldSchemaVersion in
          if oldSchemaVersion < currentSchemaVersion {
          }
        })
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
    }
}

final class RealmManager {
    
    func get<T: Object>(_ object: T.Type, primaryKey: String) -> T? {
        return DataStore.shared.realm.object(ofType: object.self, forPrimaryKey: primaryKey)
    }
    
    func getAllObjects<T: Object>(_ object: T.Type) -> [T] {
        return DataStore.shared.realm.objects(object.self).map { $0 }
    }
    
    func edit<T: Object>(_ object: T.Type, primaryKey: String, edit: (T?) -> Void) throws {
        let realm = DataStore.shared.realm
        do {
            realm.beginWrite()
            let target = realm.object(ofType: object.self, forPrimaryKey: primaryKey)
            edit(target)
            try realm.commitWrite()
        } catch {
            realm.cancelWrite()
            throw DataStoreError.transaction(error)
        }
    }

    func save<T: Object>(_ realmObject: T) throws {
        let realm = DataStore.shared.realm
        do {
            realm.beginWrite()
            realm.add(realmObject, update: .modified)
            try realm.commitWrite()
        } catch {
            realm.cancelWrite()
            throw DataStoreError.transaction(error)
        }
    }
    
    func delete<T: Object>(_ realmObject: T) throws {
        let realm = DataStore.shared.realm
        do {
            realm.beginWrite()
            realm.delete(realmObject)
            try realm.commitWrite()
        } catch {
            realm.cancelWrite()
            throw DataStoreError.transaction(error)
        }
    }
    
    func deleteAllObjects() throws {
        let realm = DataStore.shared.realm
        do {
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            realm.cancelWrite()
            throw DataStoreError.transaction(error)
        }
    }
}

extension RealmManager {
    
    func getWithPromise<T: Object>(_ object: T.Type, primaryKey: String) -> Promise<T> {
        return Promise { resolver in
            guard let obj = get(object, primaryKey: primaryKey) else {
                resolver.reject(DataStoreError.notFound("no such object in DataBase: \(object.className()), id = \(primaryKey)"))
                return
            }
            
            resolver.fulfill(obj)
        }
    }
    
    func editWithPromise<T: Object>(_ realmObject: T.Type, primaryKey: String, edit: (T?) -> Void) -> Promise<Void> {
        return Promise { resolver in
            do {
                resolver.fulfill(try self.edit(realmObject, primaryKey: primaryKey, edit: edit))
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func saveWithPromise<T: Object>(_ realmObject: T) -> Promise<Void> {
        return Promise { resolver in
            do {
                resolver.fulfill(try save(realmObject))
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func deleteWithPromise<T: Object>(_ realmObject: T) -> Promise<Void> {
        return Promise { resolver in
            do {
                resolver.fulfill(try delete(realmObject))
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func deleteAllObjectsWithPromise() -> Promise<Void> {
        return Promise { resolver in
            do {
                resolver.fulfill(try deleteAllObjects())
            } catch {
                resolver.reject(error)
            }
        }
    }
}
