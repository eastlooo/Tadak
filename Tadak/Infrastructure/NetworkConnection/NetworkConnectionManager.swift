//
//  NetworkConnectionManager.swift
//  Tadak
//
//  Created by 정동천 on 2022/10/06.
//

import Foundation
import Network

final class NetworkConnectionManager {
    
    private static let shared = NetworkConnectionManager()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var _connection: Bool = false
    
    private init() {
        self.monitor = NWPathMonitor()
    }
}

extension NetworkConnectionManager {
    
    static func checkConnection() -> Bool {
        return shared._connection
    }
    
    static func startMonitoring() {
        shared.monitor.start(queue: shared.queue)
        shared.monitor.pathUpdateHandler = { path in
            print("DEBUG: isConnected \(path.status == .satisfied) \(path.status)")
            shared._connection = (path.status == .satisfied)
        }
    }

    static func stopMonitoring() {
        shared.monitor.cancel()
    }
}
