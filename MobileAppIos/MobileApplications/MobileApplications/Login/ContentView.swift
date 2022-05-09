//
//  ContentView.swift
//  MobileApplications
//
//  Created by Octavian Custura on 09.12.2021.
//

import SwiftUI
import Network

let lightGreyColor = Color(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, opacity: 1.0)


struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @ObservedObject var keyboardResponder: KeyboardResponder = KeyboardResponder()
    
    @StateObject var monitor = Monitor()
    @StateObject var storage = Storage()
    
    func login(completionHandler: @escaping (String?) -> Void) {
        let url = URL(string: "http://\(Environment.ip):\(Environment.port)/api/auth/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String:String] = [
            "username": username,
            "password": password
        ]
        
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unkown error")
                completionHandler(nil)
                return
            }
            guard (200 ... 299) ~= response.statusCode else {
                print("Status code must be 2xx, but is \(response.statusCode)")
                print("Response = \(response)")
                completionHandler(nil)
                return
            }
            
            let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJson = responseJson as? [String: String] {
                print(responseJson)
                completionHandler(responseJson["token"] ?? nil)
            }
            return
        }
        
        task.resume()
    }
    @State var token: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    WelcomeText()
                    UserImage()
                    
                    UsernameTextField(username: $username)
                    PasswordTextField(password: $password)
                    if authenticationDidFail {
                        Text("Information not correct. Try again!")
                            .offset(y: -10)
                            .foregroundColor(.red)
                            
                    }
                    
                    Button(action: {
                        print("Pressing action button")
                        login { token in
                            if token == nil {
                                authenticationDidFail = true
                                print("Auth failed")
                            } else {
                                authenticationDidFail = false
                                authenticationDidSucceed = true
                                self.token = token!
                                print("Logged in")
                                Monitor.storage.setBearerToken(bearerToken: self.token)
                            }
                        }
                    }) {
                        LoginButtonContent()
                    }
                    NetworkStatusCheck()
                }
                .padding()
                if authenticationDidSucceed {
                    NavigationLink(destination: MainView(token: token), isActive: $authenticationDidSucceed) {
                        EmptyView()
                    }
                }
            }
            .offset(y: -keyboardResponder.currentHeight * 0.9)
            
        }.environmentObject(monitor)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



