//
//  HealthReader.swift
//  SleepyWatcher
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import HealthKit

class HealthReader: ObservableObject {
    var healthCareStore = HKHealthStore()
    var heartRateQuery: HKQuery!
    private var workouts = [HKWorkout]()
    private var statistics = [HKStatistics]()
    var timer = Timer()

    var HR: Int = 0

    init() {
//        self.requestAuthorization()
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.subscribeToHeartBeatChanges), userInfo: nil, repeats: true)
    }

    private func requestAuthorization() {
        //  HealthStoreへのアクセス承認をおこなう.
        HealthStore.shared.requestAuthorization { [unowned self] (success, error) in
            guard success, error == nil else {
                print(error ?? "error")
                return
            }
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.subscribeToHeartBeatChanges), userInfo: nil, repeats: true)
        }
    }

    @objc public func subscribeToHeartBeatChanges() {
        self.HR += 1
        print(self.HR)
        self.fetchLatestHeartRateSample(completion: { sample in
            guard let sample = sample else {
              return
            }

            /// The completion in called on a background thread, but we
            /// need to update the UI on the main.
            DispatchQueue.main.async {

                /// Converting the heart rate to bpm
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = sample
                .quantity
                .doubleValue(for: heartRateUnit)

                /// Updating the UI with the retrieved value
                print("\(Int(heartRate))")
                self.HR = Int(heartRate)
            }
          })
    }

    public func fetchLatestHeartRateSample(
      completion: @escaping (_ sample: HKQuantitySample?) -> Void) {

      /// Create sample type for the heart rate
      guard let sampleType = HKObjectType
        .quantityType(forIdentifier: .heartRate) else {
          completion(nil)
        return
      }

      /// Predicate for specifiying start and end dates for the query
      let predicate = HKQuery
        .predicateForSamples(
          withStart: Date.distantPast,
          end: Date(),
          options: .strictEndDate)

      /// Set sorting by date.
      let sortDescriptor = NSSortDescriptor(
        key: HKSampleSortIdentifierStartDate,
        ascending: false)

      /// Create the query
      let query = HKSampleQuery(
        sampleType: sampleType,
        predicate: predicate,
        limit: Int(HKObjectQueryNoLimit),
        sortDescriptors: [sortDescriptor]) { (_, results, error) in

          guard error == nil else {
            print("Error: \(error!.localizedDescription)")
            return
          }

          completion(results?[0] as? HKQuantitySample)
      }

      self.healthCareStore.execute(query)
    }
//
//    private func getWorkouts() {
//        let type = HKWorkoutType.workoutType()
//        let predicate = HKQuery.predicateForWorkouts(with: .other)  // その他のワークアウトを取得。他にはランニング等もあります
//
//        HealthStore.shared.queryExecute(sampleType: type, predicate: predicate) { [weak self] (query, samples, error) in
//            guard let `self` = self, let workouts = samples as? [HKWorkout], error == nil else { return }
//            self.workouts = workouts
//            self.workouts.forEach { self.getHeartRates(workout: $0) }
//        }
//    }
//
//    private func getHeartRates(workout: HKWorkout) {
//        guard let type = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
//        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
//        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.discreteAverage, .discreteMin, .discreteMax]) { [weak self] (query, statistic, error) in
//            guard let `self` = self, let statistic = statistic, error == nil else { return }
//            self.statistics.append(statistic)
//            print(DateFormatter.debug.string(from: statistic.startDate))
//            print("最低値 \(statistic.minimumQuantity()?.doubleValue(for: HealthStore.bpmUnit) ?? 0) bpm")
//            print("最高値 \(statistic.maximumQuantity()?.doubleValue(for: HealthStore.bpmUnit) ?? 0) bpm")
//            print("平均値 \(statistic.averageQuantity()?.doubleValue(for: HealthStore.bpmUnit) ?? 0) bpm")
//        }
//        HealthStore.shared.execute(query: query)
//    }

    public func getHR() -> Int {
        return self.HR
    }
}


