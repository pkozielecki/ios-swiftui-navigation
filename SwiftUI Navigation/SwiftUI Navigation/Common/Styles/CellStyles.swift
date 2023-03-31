//
//  CellStyles.swift
//  KISS Views
//

import SwiftUI

struct NoInsetsCellModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

extension View {
    func noInsetsCell() -> some View {
        modifier(NoInsetsCellModifier())
    }
}
