//
//  AssetsListView.swift
//  KISS Views
//

import SwiftUI

struct AssetsListView<Router: NavigationRouter>: View {
    @ObservedObject var router: Router

    var body: some View {
        List {
            Button {
                router.push(screen: .editAsset)
            } label: {
                Text("Gold")
            }
            Text("Silver")
            Text("BTC")
        }
    }
}

struct AssetsListView_Previews: PreviewProvider {
    static var previews: some View {
        AssetsListView(router: PreviewNavigationRouter())
    }
}
