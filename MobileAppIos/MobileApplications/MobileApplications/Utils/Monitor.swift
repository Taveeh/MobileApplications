//
//  Monitor.swift
//  MobileApplications
//
//  Created by Octavian Custura on 28.12.2021.
//

import Foundation
import SwiftUI
import Network

enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    public static let storage = Storage()
    @Published var status: NetworkStatus = .connected
    public static var shakenCount: Int = 0
    
    static func increaseCount() {
        Monitor.shakenCount += 1
    }
    @Published var shouldUpdate: Bool = false
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                print(path)
                if path.status == .satisfied {
                    print("Connected")
                    self.status = .connected
                    Monitor.storage.saveElements()
                    
                } else {
                    print("Disconnected")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
