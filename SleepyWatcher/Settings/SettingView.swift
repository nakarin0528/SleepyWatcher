//
//  SettingView.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/01/22.
//  Copyright © 2020 nakarin. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var startTime: Date
    @State var endTime: Date
    @State var isVibrate: Bool
    @State var napTime: Int

    let dataSendar = DataSendar()

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        let max = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        return min...max
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Start Time").font(.headline)
                    DatePicker(
                        selection: $startTime,
                        in: dateClosedRange,
                        displayedComponents: [.hourAndMinute]) {
                            Text("")
                    }
                    .labelsHidden()
                    .frame(width: 310, height:150)
                }.padding()
                .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
                .cornerRadius(15)

                VStack(alignment: .leading) {
                    Text("End Time").font(.headline)
                    DatePicker(
                        selection: $endTime,
                        in: dateClosedRange,
                        displayedComponents: [.hourAndMinute]) {
                            Text("")
                    }
                    .labelsHidden()
                    .frame(width: 310, height:150)
                }.padding()
                .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
                .cornerRadius(15)

                VStack {
                    VStack {
                        Toggle(isOn: $isVibrate) {
                            Spacer()
                            Text("Quick Vibration").font(.headline)
                        }
                    }.padding(8)
                }
                .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
                .cornerRadius(15)

                VStack {
                    VStack {
                        Stepper(value: $napTime, in:1...30) {
                            Spacer()
                            Text("Nap Time: \(self.napTime) min").font(.headline)
                        }
                    }.padding(8)
                }
                .background(Color(#colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1)))
                .cornerRadius(15)
            }
        }
        .padding([.horizontal])
        .navigationBarTitle("Monitor Setting")
        .navigationBarItems(trailing:
            Button(action: {
                self.save()
            }) {
                Image(systemName: "checkmark")
                    .font(Font.title.weight(.regular))
            }
        )
    }

    private func save() {
        UserSetting.startTime = self.startTime
        UserSetting.endTime = self.endTime
        UserSetting.isVibrate = self.isVibrate
        UserSetting.napTime = self.napTime
        dataSendar.sendSettings()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            startTime: UserSetting.startTime,
            endTime: UserSetting.endTime,
            isVibrate: UserSetting.isVibrate,
            napTime: UserSetting.napTime
        )
    }
}
