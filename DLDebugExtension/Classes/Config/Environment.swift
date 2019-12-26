//
//  Environment.swift
//  DLDebugExtension
//
//  Created by Daniel Lin on 2019/12/24.
//  Copyright (c) 2019 Daniel Lin. All rights reserved.

#if DEBUG

@objc
public enum Environment: Int, Codable {
    case debug
    case test
    case release

    private var _serverURLsKey: String {
        return "\(self)_server_urls"
    }

    private static let _currentServerURLKey = "current_server_url"
    private static let _currentEnvironmentKey = "current_environment"

    public var serverURLs: [ServerURL] {
        return UserDefaults.standard.object([ServerURL].self, with: _serverURLsKey) ?? []
    }

    public func setServerURLs(_ urls: (name: String, url: String)...) {
        var serverURLs = [ServerURL]()
        for (name, url) in urls {
            let serverURL = ServerURL(name: name, url: url)
            serverURLs.append(serverURL)
        }
        UserDefaults.standard.set(object: serverURLs, forKey: _serverURLsKey)
    }

    private func _containsURL(_ url: String) -> Bool {
        for serverURL in serverURLs {
            if serverURL.url == url {
                return true
            }
        }
        return false
    }

    public func setCurrentServerURL(_ url: String) {
        UserDefaults.standard.set(url, forKey: Environment._currentServerURLKey)
        UserDefaults.standard.set(object: self, forKey: Environment._currentEnvironmentKey)
    }

    public static func currentServerURL(defaultURL: String) -> String {
        if let url = UserDefaults.standard.string(forKey: _currentServerURLKey) {
            return url
        }

        if Environment.debug._containsURL(defaultURL) {
            Environment.debug.setCurrentServerURL(defaultURL)
        } else if Environment.test._containsURL(defaultURL) {
            Environment.test.setCurrentServerURL(defaultURL)
        } else if Environment.release._containsURL(defaultURL) {
            Environment.release.setCurrentServerURL(defaultURL)
        } else {
            Environment.debug.setCurrentServerURL(defaultURL)
        }
        return defaultURL
    }

    public static var current: Environment {
        return UserDefaults.standard.object(Environment.self, with: _currentEnvironmentKey) ?? .debug
    }

    public static func appKeys(_ keys: (key: String, env: Environment)...) -> String {
        for key in keys {
            if key.env == Environment.current {
                return key.key
            }
        }
        return keys[0].key
    }
}

public struct ServerURL: Codable {
    let name: String
    let url: String
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
    }
}

#endif
