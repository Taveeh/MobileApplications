//
//  PasswordTextFiekd.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import Foundation
import SwiftUI

struct PasswordTextField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

