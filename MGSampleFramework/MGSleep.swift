//
//  MGSleep.swift
//  MGSampleFramework
//
//  Created by Mihai Georgescu on 28/09/2018.
//  Copyright © 2018 Mihai Georgescu. All rights reserved.
//

import Foundation

/// This class does nothing, it is just to have something to use from this framework.
public class MGSleep {

    public let name: String

    public init(name: String) {
        self.name = name
    }

    public func goToSleep(time: TimeInterval = 1, callback: (() -> Void)?) {
        // Print is used intentionally to see it in the console from the other frameworks when it is used.
        print("I am going to sleep")

        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            print("I woke up")
            callback?()
        }
    }
}
