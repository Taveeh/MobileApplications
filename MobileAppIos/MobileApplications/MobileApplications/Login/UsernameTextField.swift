//
//  UsernameTextField.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import Foundation
import SwiftUI

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
