//
//  NetworkStatusCheck.swift
//  MobileApplications
//
//  Created by Octavian Custura on 28.12.2021.
//

import SwiftUI

struct NetworkStatusCheck: View {
    @EnvironmentObject var monitor: Monitor
    var body: some View {
            if monitor.status == .connected {
                Text(monitor.status.rawValue)
                    .foregroundColor(.green)
                    .onAppear{
                        raiseNotification(connection: .connected)
                    }
            } else {
                Text(monitor.status.rawValue)
                    .foregroundColor(.red)
                    .onAppear {
                        raiseNotification(connection: .disconnected)
                    }
            }
        
        
    }
    
    func raiseNotification(connection: NetworkStatus) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
            success, error in
            if success {
                print("authorization granted")
            } else if let error = error  {
                print(error.localizedDescription)
            }
        }
        // 2.
        let content = UNMutableNotificationContent()
        content.title = "Connection Status"
        content.body = "Connection: \(connection.rawValue)"
        content.sound = UNNotificationSound.default
        
        // 3.
        let imageName = "41983-full"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else {
            print("No image found")
            return
            
        }
        
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        content.attachments = [attachment]
        
        // 4.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 5.
        UNUserNotificationCenter.current().add(request)
        print("got here")
    }
}


struct NetworkStatusCheck_Previews: PreviewProvider {
    static var previews: some View {
        NetworkStatusCheck()
    }
}
