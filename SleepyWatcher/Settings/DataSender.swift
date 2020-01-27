//
//  SendDataToWatch.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/27.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Foundation
import WatchConnectivity

final class DataSendar: NSObject, WCSessionDelegate {
    private var session: WCSession!

    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }

    func sendSettings() {
        print(self.session.isReachable)
        let contents: [String:Any] = [
            "startTime": UserSetting.startTime,
            "endTime": UserSetting.endTime,
            "isVibrate": UserSetting.isVibrate,
            "napTime": UserSetting.napTime
        ]
//        self.session.sendMessage(contents, replyHandler: { (replyMessage) -> Void in
//            print("session: receive from apple watch")
//            print("AppleWatch: \(replyMessage)")
//        }) { error -> Void in
//            print(error)
//        }

        WCSession.default.transferUserInfo(contents)
    }

    // protocol
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("session: active")
        case .inactive:
            print("session: inactive")
        case .notActivated:
            print("session: not active")
        default:
            print("session: What happend!?")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session: did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("session: did deactive")
    }
}
