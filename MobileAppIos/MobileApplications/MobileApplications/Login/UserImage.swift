//
//  UserImage.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import Foundation
import SwiftUI

struct UserImage: View {
    var body: some View {
        Image("41983-full")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}
