//
//  ContentView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject(initialValue: HeartRateModel()) var heartRateModel: HeartRateModel
    @State var isShowing: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List(heartRateModel.heartRates) { item in
                    HeartRateRow(pulse: item)
                }
                Button(
                    action: self.heartRateModel.readHeartRate,
                    label: {
                        Text("read ❤️")
                })
                .cornerRadius(20)
            }.navigationBarTitle("HR(30 min)")
        }


    }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


struct HeartRateRow: View {
    var pulse: Pulse

    var body: some View {
        HStack {

            Text(String(Int(pulse.pulse)))
            Text(formatter(date: pulse.date))
        }
    }

    func formatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}
