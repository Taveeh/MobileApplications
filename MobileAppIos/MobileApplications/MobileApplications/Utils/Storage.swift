//
//  Storage.swift
//  MobileApplications
//
//  Created by Octavian Custura on 28.12.2021.
//

import Foundation
import SwiftUI


class Storage: ObservableObject {    
    var elements: [Coffee] = []
    
    var bearerToken: String = ""
    
    func addElement(coffee: Coffee) {
        elements.append(coffee)
    }
    
    func setBearerToken(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    func updateElement(coffee: Coffee) {
        let url = URL(string: "http://\(Environment.ip):\(Environment.port)/api/coffee/\(coffee.cid ?? "-1")")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let dateFormatter = DateFormatter()
        print("Date: ", coffee.date)
        let parameters: [String:Any] = [
            "_id": coffee.cid,
            "title": coffee.title,
            "mark": Int(coffee.mark ),
            "description": coffee.description,
            "date": dateFormatter.string(from: coffee.date),
            "recommended": coffee.recommended,
            "photo": coffee.photo
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error as? NSError, error.domain == NSURLErrorDomain {
                    print("Cannot connect to server")
                } else {
                    print("error", error ?? "Unkown error")
                }
                return
            }
            guard (200 ... 299) ~= response.statusCode else {
                print("Status code must be 2xx, but is \(response.statusCode)")
                print("Response = \(response)")
                return
            }
            
        }
        task.resume()

    }
    func saveElements() {
        print("Saving elements...")
        elements.forEach{ coffee in
            print("\(coffee.id) -- \(coffee.title)")
            self.updateElement(coffee: coffee)
        }
        elements.removeAll()
    }
}
