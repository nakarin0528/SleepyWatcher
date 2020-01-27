//
//  SettingModel.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2020/01/27.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Combine
import Foundation

final class SettingModel: ObservableObject {
    @Published var startTime: Date = UserSetting.startTime
    @Published var endTime: Date = UserSetting.endTime
    @Published var isVibrate: Bool = UserSetting.isVibrate
    @Published var napTime: Int = UserSetting.napTime

    func reflesh() {
        DispatchQueue.main.async {
            self.startTime = UserSetting.startTime
            self.endTime = UserSetting.endTime
            self.isVibrate = UserSetting.isVibrate
            self.napTime = UserSetting.napTime
        }
    }
}
