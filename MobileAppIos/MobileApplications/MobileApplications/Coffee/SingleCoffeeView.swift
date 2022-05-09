//
//  SingleCoffeeView.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import SwiftUI
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
struct SingleCoffeeView: View {
    var bearerToken: String
    var cid: String = ""
    @State var title: String = ""
    @State var description: String = ""
    @State var mark: String = ""
    @State var recommended: Bool = false
    @State var date: Date = Date()
    var photo: String = ""
    @Binding var elements: [Coffee]
    
    @EnvironmentObject var monitor: Monitor
    func updateCoffee() {
        print(monitor.status.rawValue)
        let url = URL(string: "http://\(Environment.ip):\(Environment.port)/api/coffee/\(cid)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        let dateFormatter = DateFormatter()
        print("Date: ", date)
        let parameters: [String:Any] = [
            "_id": cid,
            "title": title,
            "mark": Int(mark) ?? 0,
            "description": description,
            "date": dateFormatter.string(from: date),
            "recommended": recommended,
            "photo": photo
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let coffee = Coffee(cid: cid, title: title, mark: Int16(mark) ?? 0, description: description, date: date, recommended: recommended, photo: photo)
            
            elements.remove(at: elements.firstIndex(where:{coffee in
                coffee.cid == cid
            }) ?? 0)
            elements.append(coffee)
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error as? NSError, error.domain == NSURLErrorDomain {
                    print("Cannot connect to server")
                    Monitor.storage.addElement(coffee: coffee)
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
    
    func increaseCount() {
        Monitor.increaseCount()
    }
    
    @State var animationAmmount = 1
    var body: some View {
        VStack {
            HStack {
                Text("Shaken count:")
                Text(String(Monitor.shakenCount))
            }.animation(
                .easeOut(duration: 5)
                    .repeatForever(),
                value: animationAmmount
            ).onAppear {
                animationAmmount = 2
            }
            
            Image("coffee2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 75)
                .animation(.easeInOut(duration: 2), value: animationAmmount)
                .onAppear {
                    animationAmmount += 1
                }
                
            Group {
                HStack {
                    Text("Title: ")
                    Spacer()
                    TextField("Enter Title Here", text: $title)
                }
                HStack {
                    Text("Description: ")
                    Spacer()
                    TextField("Enter Description Here", text: $description)
                }
                HStack {
                    Text("Mark: ")
                    Spacer()
                    TextField("Enter Mark Here", text: $mark)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Recommended: ")
                    Spacer()
                    CheckBoxView(isChecked: $recommended)
                }
                HStack {
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                }
            }
            
            Button(action: {
                updateCoffee()
            }) {
                Text("Update")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }.animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmmount)
            .onAppear {
                animationAmmount += 1
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
            self.increaseCount()
            print("Hehe shake it shake it boy")
        }.refreshable {
            print("Refresh")
        }
    }
}

struct SingleCoffeeView_Previews: PreviewProvider {
    
    static var previews: some View {
        SingleCoffeeView(bearerToken: "val", cid: "", title: "Test",description: "Test Description", mark: "12", recommended: true, date: Date(), photo: "nothing", elements: .constant([]))
    }
}
