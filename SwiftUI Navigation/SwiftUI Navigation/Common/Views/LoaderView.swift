//
//  LoaderView.swift
//  KISS Views
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack(alignment: .center) {
            ProgressView("Checking...")
                .tint(.primary)
                .scaleEffect(2)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 200, height: 150)
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
