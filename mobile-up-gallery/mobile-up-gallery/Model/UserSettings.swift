//
//  UserSettings.swift
//  mobile-up-gallery
//
//  Created by Илья Чуб on 30.03.2022.
//

import Foundation

final class UserSettings {
    private enum SettingKeys: String {
        case token
    }
    static var token: String? {
        get {
            let key = SettingKeys.token.rawValue
            return UserDefaults.standard.string(forKey: key)
        } set {
            let key = SettingKeys.token.rawValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
