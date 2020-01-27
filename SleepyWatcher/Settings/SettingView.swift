//
//  SettingView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/22.
//  Copyright © 2020 nakarin. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State var isVibrate: Bool = UserSetting.isVibrate
    @State var napTime: Int = UserSetting.napTime
    @State var selectedDate = Date()

    let dataSendar = DataSendar()

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        return min...max
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    DatePicker(
                        selection: $selectedDate,
                        in: dateClosedRange,
                        displayedComponents: [.hourAndMinute]) {
                            Text("モニタリングしたい時間")
                    }.labelsHidden()
                    Toggle(isOn: $isVibrate) {
                        Spacer()
                        Text("検知したら振動をあたえる")
                    }
                    Stepper(value: $napTime, in:1...30) {
                        Spacer()
                        Text("昼寝時間: \(self.napTime) min")
                    }
                }
                .padding()

                Button(
                    action: self.save,
                    label: {
                        Text("save")
                })
            }
            .navigationBarTitle("モニタリング設定")
        }
    }

    private func save() {
        UserSetting.isVibrate = self.isVibrate
        UserSetting.napTime = self.napTime
        dataSendar.sendSettings()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environment(\.colorScheme, .dark)
    }
}
