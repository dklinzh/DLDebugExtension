//
//  _FLEX.swift
//  DLDebugExtension
//
//  Created by Daniel Lin on 2019/12/20.
//  Copyright (c) 2019 Daniel Lin. All rights reserved.

#if DEBUG && canImport(FLEX)

import FLEX

struct _FLEX {
    static var alertAction: UIAlertAction {
        let flex = FLEXManager.shared()!
        return UIAlertAction(title: "FLEX", style: !flex.isHidden ? .destructive : .default) { _ in
            if flex.isHidden {
                flex.showExplorer()
            } else {
                flex.hideExplorer()
            }
            _isEnabled.toggle()
        }
    }

    private static var _isEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: DebugMode.flex.enabledKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: DebugMode.flex.enabledKey)
        }
    }

    public static func setup(ignoredHosts: [String]? = nil) {
        if let flex = FLEXManager.shared() {
            flex.isNetworkDebuggingEnabled = true
            flex.networkRequestHostBlacklist = ignoredHosts
            if _isEnabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    flex.showExplorer()
                }
            }
        }
    }

    static func enable() {
        FLEXManager.shared()!.showExplorer()
    }

    static func disable() {
        FLEXManager.shared()!.hideExplorer()
    }
}

#endif
