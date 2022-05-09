//
//  MainView.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import SwiftUI


struct MainView: View {
    private var bearerToken: String
    
    @State var elements: [Coffee] = []
    @EnvironmentObject var monitor: Monitor
    init(token: String) {
        bearerToken = token
        fetchData()
    }
    
    @State var searchText = ""

    
    func fetchElements(completionHandler: @escaping ([Any]) -> Void)  {
        let url = URL(string: "http://\(Environment.ip):\(Environment.port)/api/coffee")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unkown error")
                return
            }
            guard (200 ... 299) ~= response.statusCode else {
                print("Status code must be 2xx, but is \(response.statusCode)")
                print("Response = \(response)")
                return
            }
            let responseJson = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJson = responseJson as? [[String:Any]] {
                completionHandler(responseJson)
            }
        }
        
        task.resume()
    }
    
    func fetchData()  {
        self.fetchElements { coffees in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
            for coffeeElement in coffees {
                let dateString = (coffeeElement as! [String:Any])["date"] as! String
                let date: Date = dateFormatter.date(from: dateString) ?? Date()
                let coffee = Coffee(
                    cid: (coffeeElement as! [String:Any])["_id"] as? String ?? nil,
                    title: (coffeeElement as! [String:Any])["title"] as! String,
                    mark: (coffeeElement as! [String:Any])["mark"] as! Int16,
                    description: (coffeeElement as! [String:Any])["description"] as! String,
                    date: date,
                    recommended: (coffeeElement as! [String:Any])["recommended"] as! Bool,
                    photo: (coffeeElement as! [String:Any])["photo"] as? String ?? "")
                elements.append(coffee)
            }
        }
    }

    var body: some View {
        if elements.isEmpty {
            let _ = fetchData()
        }
        VStack {
            Text("Coffees").font(.system(size: 30, weight: .black, design: .rounded))
            SearchBar(text: $searchText)
                .padding(.top)
            if !elements.isEmpty {
                List(elements.filter({
                    searchText.isEmpty ? true : $0.title.contains(searchText)
                })) {
                    item in
                    NavigationLink(destination: SingleCoffeeView(bearerToken: bearerToken, cid: item.cid ?? "", title: item.title, description: item.description, mark: (item.mark as NSNumber).stringValue, recommended: item.recommended, date: item.date, photo: item.photo, elements: $elements)) {
                        Text(item.title)
                    }
                }
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(token: "Val")
    }
}
