//
//  HostingController.swift
//  SleepyWatcher WatchKit Extension
//
//  Created by yiheng on 2019/12/29.
//  Copyright © 2019 nakarin. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import HealthKit

class HostingController: WKHostingController<ContentView> {
    
    override var body: ContentView {
        return ContentView()
    }

    override func willActivate() {
        super.willActivate()
    }
}
