//
//  HeartRateModel.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/22.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Combine
import HealthKit
//import Accelerate

final class HeartRateModel: ObservableObject {

    @Published var heartRates: [Pulse]
    @Published var isReading: Bool = false
    @Published var missCount: Int = 0

    private let healthStore = HKHealthStore()
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    private let heartRateUnit = HKUnit(from: "count/min")
    private var heartRateQuery: HKQuery?

    init() {
        self.heartRates = []
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

    }

    func readHeartRate() {
        self.heartRates.removeAll()
        self.isReading = true
        self.heartRateQuery = self.createStreamingQuery()
        self.healthStore.execute(self.heartRateQuery!)
    }


    private func createStreamingQuery() -> HKQuery {
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeInterval: -60*30, since: Date()), end: Date(), options: [.strictStartDate])
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
            self.heartRates.append(Pulse(pulse: $0.quantity.doubleValue(for: heartRateUnit), date: $0.startDate))
        }

    }
}


struct Pulse: Identifiable {
    let id = UUID()
    let pulse: Double
    let date: Date
}

