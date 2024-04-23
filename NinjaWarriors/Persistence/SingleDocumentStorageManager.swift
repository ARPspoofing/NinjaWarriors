//
//  StorageManager.swift
//  NinjaWarriors
//
//  Created by Jivesh Mohan on 21/4/24.
//

import Foundation

protocol SingleDocumentStorageManager {
    func save<T: Codable>(_ object: T)
    func load<T: Decodable>(_ completion: @escaping (T?, Error?) -> Void)
}