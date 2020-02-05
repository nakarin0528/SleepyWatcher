//
//  HostingController.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import HealthKit
import UserNotifications
import WatchConnectivity

class HostingController: WKHostingController<CountDownView>, WKExtensionDelegate, WCSessionDelegate {

    fileprivate var wcBackgroundTasks: [WKWatchConnectivityRefreshBackgroundTask] = []
    var session: WCSession!
    private let settingModel = SettingModel()
    private let alarmModel = AlarmModel(session: WKExtendedRuntimeSession())

    override var body: CountDownView {
        return CountDownView(model: alarmModel)
//        return SettingView(settingModel: settingModel)
//        return ContentView()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        WCSession.default.addObserver(self,
                                      forKeyPath: "hasContentPending",
                                      options: [],
                                      context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?,
                                     of object: Any?,
                                     change: [NSKeyValueChangeKey : Any]?,
                                     context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            let session = WCSession.default
            if session.activationState == .activated && !session.hasContentPending {
                self.wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }
                self.wcBackgroundTasks.removeAll()
            }
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("receiveUserInfo: \(userInfo)")

        if let startAlarm = userInfo["startAlarm"] as? Bool {
            if startAlarm {
                self.alarmModel.runTimer()
                return
            }
        }

        guard
            let startTime = userInfo["startTime"] as? Date,
            let endTime = userInfo["endTime"] as? Date,
            let isVibrate = userInfo["isVibrate"] as? Bool,
            let napTime = userInfo["napTime"] as? Int
        else {
            print("error: what happend!?")
            return
        }

        UserSetting.startTime = startTime
        UserSetting.endTime = endTime
        UserSetting.isVibrate = isVibrate
        UserSetting.napTime = napTime
        settingModel.reflesh()
        print("Setting updated!")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session")
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let task = task as? WKWatchConnectivityRefreshBackgroundTask {
                self.wcBackgroundTasks.append(task)
            }
        }
    }
}
