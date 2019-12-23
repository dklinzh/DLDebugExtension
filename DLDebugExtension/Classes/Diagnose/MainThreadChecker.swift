//
//  MainThreadChecker.swift
//  DLDebugExtension
//
//  Created by Daniel Lin on 2019/7/1.
//  Copyright (c) 2019 Daniel Lin. All rights reserved.

#if DEBUG

import UIKit

extension UIApplication {
    private class ApplicationState {
        static let shared = ApplicationState()

        var current = UIApplication.State.inactive

        private init() {
            let center = NotificationCenter.default
            let mainQueue = OperationQueue.main
            center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: mainQueue) { _ in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: mainQueue) { _ in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: mainQueue) { _ in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: mainQueue) { _ in
                self.current = UIApplication.shared.applicationState
            }
            center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: mainQueue) { _ in
                self.current = UIApplication.shared.applicationState
            }
        }
    }

    @objc
    private var __applicationState: UIApplication.State {
        if Thread.isMainThread {
            return self.__applicationState
        } else {
            return ApplicationState.shared.current
        }
    }

    public struct debug {
        /// To fix warnings if `-[UIApplication applicationState]` be called on a background thread.
        public static func mainThreadApplicationState() {
            if let originalMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: applicationState)),
                let swizzledMethod = class_getInstanceMethod(UIApplication.self, #selector(getter: __applicationState)) {
                _ = ApplicationState.shared
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
}

#endif
