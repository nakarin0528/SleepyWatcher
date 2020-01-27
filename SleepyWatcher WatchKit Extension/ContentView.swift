//
//  ContentView.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation
import SwiftUI
import WatchKit

struct ContentView: View {
    @ObservedObject(initialValue: HeartRateModel()) var heartRateModel: HeartRateModel

    var body: some View {
        VStack {
            self.showHeartRate(pulse: heartRateModel.heartRates.last)
            Button(
                action: self.tapReadButton,
                label: {
                    Text(self.heartRateModel.isReading ? "stop reading":"read ❤️")
            })
            .background(self.heartRateModel.isReading ? Color.red:Color.green)
            .cornerRadius(20)
        }
    }

    func showHeartRate(pulse: Pulse?) -> AnyView {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium

        if let pulse = pulse {
            return AnyView(
                VStack {
                    HStack {
                        Text("HeartRate:")
                        Text(String(Int(pulse.pulse)))
                            .foregroundColor(Color.pink)
                            .fontWeight(.bold)
                    }
                    Text("Time: \(dateFormatter.string(from: pulse.date))")
                }
            )
        } else {
            return AnyView(
                VStack {
                    Text("HeartRate: error")
                    Text("Time: \(dateFormatter.string(from: Date()))")
                }
            )
        }
    }

    func tapReadButton() {
        if self.heartRateModel.isReading {
            self.heartRateModel.stopReadHeartRate()
        } else {
            self.heartRateModel.readHeartRate()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
