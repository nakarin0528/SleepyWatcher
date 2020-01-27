//
//  UserDefault.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/27.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let defaults = UserDefaults(suiteName: "group.com.sleepywatcher.userdefault")

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            defaults?.synchronize()
            return defaults?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults?.set(newValue, forKey: key)
            defaults?.synchronize()
        }
    }
}

struct UserSetting {
    @UserDefault("starttTime", defaultValue: Date())
    static var startTime: Date

    @UserDefault("endTime", defaultValue: Date())
    static var endTime: Date

    @UserDefault("isVibrate", defaultValue: true)
    static var isVibrate: Bool

    @UserDefault("napTime", defaultValue: 20)
    static var napTime: Int
}
