//
//  HeartRateModel.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/22.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Combine
import HealthKit
import WatchConnectivity

final class HeartRateModel: NSObject, ObservableObject {
    private var session: WCSession!

    @Published var heartRates: [Pulse] = []
    @Published var hr: [Double] = []
    @Published var heartRatesChartData: [(String, Double)] = []
    @Published var isReading: Bool = false
    @Published var missCount: Int = 0

    private let healthStore = HKHealthStore()
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    private let heartRateUnit = HKUnit(from: "count/min")
    private var heartRateQuery: HKQuery?

    override init() {
        super.init()

        guard HKHealthStore.isHealthDataAvailable() else {
            print("HelthStore: not availble")
            return
        }
        let dataTypes = Set([heartRateType])
        self.healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            guard success else {
                print("HealthStore: not allowed!")
                return
            }
        }

        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        self.readHeartRate()
    }

    func readHeartRate() {
        self.hr.removeAll()
        self.heartRates.removeAll()
        self.heartRatesChartData.removeAll()
        self.isReading = true
        self.heartRateQuery = self.createStreamingQuery()
        self.healthStore.execute(self.heartRateQuery!)
    }

    func sendStartAlarm() {
            let contents: [String:Any] = ["startAlarm": true]
            WCSession.default.transferUserInfo(contents)
    }

    private func createStreamingQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeInterval: -60*60*3, since: Date()), end: Date(), options: [.strictStartDate])
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
            DispatchQueue.main.async {
                if let _ = error {
                    self.missCount += 1
                } else {
                    self.addSamples(samples)
                }
            }
        }
        query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            DispatchQueue.main.async {
                if let _ = error {
                    self.missCount += 1
                } else {
                    self.addSamples(samples)
                }
            }
        }
        return query
    }

    private func addSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }
        samples.forEach {
            if $0.device?.name == "Apple Watch" {
                let pulse = Pulse(pulse: $0.quantity.doubleValue(for: heartRateUnit), date: $0.startDate)
                self.heartRates.append(pulse)
            }
//            self.heartRatesChartData.append((Helper.formatter(date: pulse.date), pulse.pulse))
        }
        self.hr = heartRates.map{$0.pulse}
    }
}

extension HeartRateModel: WCSessionDelegate {
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


struct Pulse: Identifiable {
    let id = UUID()
    let pulse: Double
    let date: Date
}

