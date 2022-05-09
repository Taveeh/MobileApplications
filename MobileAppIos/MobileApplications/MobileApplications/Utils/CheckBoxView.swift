//
//  CheckBoxView.swift
//  MobileApplications
//
//  Created by Octavian Custura on 12.12.2021.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    func toggle() {
        isChecked = !isChecked
    }
    var body: some View {
        HStack{
            Image(systemName: isChecked ? "checkmark.square": "square")
                .onTapGesture {
                    toggle()
                }
        }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckBoxView(isChecked: .constant(true))
            CheckBoxView(isChecked: .constant(false))
        }
        
        
    }
}
