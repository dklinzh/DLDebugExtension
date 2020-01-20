//
//  _CocoaDebug.swift
//  DLDebugExtension
//
//  Created by Daniel Lin on 2019/12/20.
//  Copyright (c) 2019 Daniel Lin. All rights reserved.

#if DEBUG && canImport(CocoaDebug)

import CocoaDebug

struct _CocoaDebug {
    static var alertAction: UIAlertAction {
        return UIAlertAction(title: "CocoaDebug", style: _isEnabled ? .destructive : .default) { _ in
            if _isEnabled {
                CocoaDebug.disable()
            } else {
                enable()
            }
            _isEnabled.toggle()
        }
    }

    private static var _isEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: DebugMode.cocoadebug.enabledKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: DebugMode.cocoadebug.enabledKey)
        }
    }

    private static var _shakeToHide = true

    static func setup(mainHost: String? = nil,
                      ignoredHosts: [String]? = nil,
                      onlyFocusedHosts: [String]? = nil,
                      logMaxCount: Int = 1_000,
                      emailToRecipients: [String]? = nil,
                      emailCcRecipients: [String]? = nil,
                      themeColor: UIColor? = nil,
                      shakeToHide: Bool = true) {
        CocoaDebugSettings.shared.disableLogMonitoring = true // FIX: NSLog() incomplete output 

        CocoaDebug.serverURL = mainHost
        CocoaDebug.ignoredURLs = ignoredHosts
        CocoaDebug.onlyURLs = onlyFocusedHosts
        CocoaDebug.logMaxCount = logMaxCount
        CocoaDebug.emailToRecipients = emailToRecipients
        CocoaDebug.emailCcRecipients = emailCcRecipients
        if let themeColor = themeColor {
            CocoaDebug.mainColor = themeColor.hexString
        }
        _shakeToHide = shakeToHide
        if _isEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                enable()
            }
        }
    }

    static func setTabBarControllers(_ children: [UIViewController]) {
        CocoaDebug.tabBarControllers = children
        if _isEnabled {
            enable()
        }
    }

    static func enable() {
        CocoaDebug.enable()
        CocoaDebugSettings.shared.responseShake = _shakeToHide
    }

    static func disable() {
        CocoaDebug.disable()
    }
}

extension UIColor {
    var hexString: String {
        let components: [Int] = {
            let comps = cgColor.components!
            let components = comps.count == 4 ? comps : [comps[0], comps[0], comps[0], comps[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
}

#endif
