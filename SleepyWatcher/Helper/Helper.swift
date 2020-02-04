//
//  Helper.swift
//  SleepyWatcher
//
//  Created by yiheng on 2020/02/02.
//  Copyright © 2020 nakarin. All rights reserved.
//

import Foundation

struct Helper {
    static func formatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
