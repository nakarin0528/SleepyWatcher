//
//  Alarm.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2020/01/27.
//  Copyright © 2020 nakarin. All rights reserved.
//

import WatchKit

final class AlarmModel: NSObject, ObservableObject {
    private var sleepTimer: Timer?
    private let timeScale: Int = 60

    @Published var seconds = UserSetting.napTime * 60

    var session: WKExtendedRuntimeSession!

    init(session: WKExtendedRuntimeSession) {
        super.init()
        self.session = session
        self.session.delegate = self
        self.session.start(at: Date())
    }

    func startSession() {
        self.session.start(at: Date())
//        self.session.start()
    }

    func runTimer() {

        DispatchQueue.main.async {
            if UserSetting.isVibrate {
                self.runVibration()
            } else {
                self.seconds = UserSetting.napTime * self.timeScale
                if self.sleepTimer == nil {
                    self.sleepTimer = Timer.scheduledTimer(
                        timeInterval: 1,
                        target: self,
                        selector: #selector(self.updateTimer),
                        userInfo: nil,
                        repeats: true)
                    self.sleepTimer?.fire()
                } else {
                    print("すでにstartしてるよ")
                }
            }
        }
    }

    func stopAlarm() {
        self.session.invalidate()
        DispatchQueue.main.async {
            self.seconds = UserSetting.napTime * self.timeScale
        }
        self.startSession()
    }

    @objc private func updateTimer() {
        print("\(seconds) sec")
        if self.seconds != 0 {
            self.seconds -= 1
        } else {
            self.sleepTimer?.invalidate()
            self.sleepTimer = nil

            if self.session.state != .invalid && self.session.state != .scheduled {
                self.session.notifyUser(hapticType: .notification) { (pointa) -> TimeInterval in
                    print(pointa)
                    return 1.0
                }
            }
        }
    }

    private func runVibration() {
        if self.session.state != .invalid && self.session.state != .scheduled {
            self.seconds = 0
            self.session.notifyUser(hapticType: .notification) { (pointa) -> TimeInterval in
                return 1.0
            }
        }
    }
}

extension AlarmModel: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("RuntimeSession: did start")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("RuntimeSession: expire")
    }


    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }
}
