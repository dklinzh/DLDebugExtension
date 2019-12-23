//
//  Debugger.swift
//  DLDebugExtension
//
//  Created by Daniel Lin on 2019/12/17.
//  Copyright (c) 2019 Daniel Lin. All rights reserved.

#if DEBUG

public enum DebugMode {
    #if canImport(CocoaDebug)
    case cocoadebug
    #endif

    #if canImport(FLEX)
    case flex
    #endif

    var enabledKey: String {
        return "debug_\(self)_enabled"
    }
}

public struct Debugger {
    private var _viewController: UIViewController?

    init(viewController: UIViewController) {
        _viewController = viewController
    }

    public static func setup(mainHost: String? = nil,
                             ignoredHosts: [String]? = nil,
                             onlyFocusedHosts: [String]? = nil,
                             logMaxCount: Int = 1_000,
                             emailToRecipients: [String]? = nil,
                             emailCcRecipients: [String]? = nil,
                             themeColor: UIColor? = nil,
                             shakeToHide: Bool = true) {
        #if canImport(CocoaDebug)
        _CocoaDebug.setup(mainHost: mainHost,
                          ignoredHosts: ignoredHosts,
                          onlyFocusedHosts: onlyFocusedHosts,
                          logMaxCount: logMaxCount,
                          emailToRecipients: emailToRecipients,
                          emailCcRecipients: emailCcRecipients,
                          themeColor: themeColor,
                          shakeToHide: shakeToHide)
        #endif

        #if canImport(FLEX)
        _FLEX.setup(ignoredHosts: ignoredHosts)
        #endif
    }

    public static func setTabBarControllers(_ children: [UIViewController]) {
        #if canImport(CocoaDebug)
        _CocoaDebug.setTabBarControllers(children)
        #endif
    }

    public static func enable(mode: DebugMode) {
        switch mode {
        #if canImport(CocoaDebug)
        case .cocoadebug:
            _CocoaDebug.enable()
        #endif

        #if canImport(FLEX)
        case .flex:
            _FLEX.enable()
        #endif
        }
    }

    public static func disable(mode: DebugMode) {
        switch mode {
        #if canImport(CocoaDebug)
        case .cocoadebug:
            _CocoaDebug.disable()
        #endif

        #if canImport(FLEX)
        case .flex:
            _FLEX.disable()
        #endif
        }
    }

    public func showModeOptions() {
        guard let viewController = _viewController else {
            return
        }

        let alert = UIAlertController(title: "Debug Modes", message: "Select one or more of the modes below.", preferredStyle: .actionSheet)
        #if canImport(CocoaDebug)
        alert.addAction(_CocoaDebug.alertAction)
        #endif

        #if canImport(FLEX)
        alert.addAction(_FLEX.alertAction)
        #endif

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    public var debug: Debugger {
        return Debugger(viewController: self)
    }
}

#endif
