//
//  LoginButtonContent.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import Foundation
import SwiftUI

struct LoginButtonContent: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
