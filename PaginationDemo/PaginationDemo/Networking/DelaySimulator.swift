//
//  DelaySimulator.swift
//  PaginationDemo
//
//  Created by Habibur_Rahman on 18/7/26.
//

import Foundation

enum DelaySimulator {

    static func randomDelay() async {

        let seconds = Double.random(in: 0.5...2.0)

        try? await Task.sleep(
            for: .seconds(seconds)
        )
    }
}
