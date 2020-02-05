//
//  CountDownView.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2020/01/29.
//  Copyright © 2020 nakarin. All rights reserved.
//

import SwiftUI
import WatchKit

struct CountDownView: View {
    @ObservedObject var model: AlarmModel
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                Text("\(self.model.seconds)").font(.title)
                Text("sec").alignmentGuide(.bottom, computeValue: { d in d[.bottom] })
            }
            if self.model.seconds == 0 {
                Button(
                    action: self.model.stopAlarm,
                    label: {
                        Text("stop alarm")
                })
            }
        }
    }
}


struct CountDownView_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView(model: AlarmModel(session: WKExtendedRuntimeSession()))
    }
}
