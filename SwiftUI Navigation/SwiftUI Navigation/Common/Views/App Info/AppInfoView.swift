//
//  AppInfoView.swift
//  KISS Views
//

import Foundation
import SwiftUI

struct AppInfoView<ViewModel>: View where ViewModel: AppInfoViewModel {
    @StateObject var viewModel: ViewModel

    var body: some View {

        VStack(alignment: .center, spacing: 30) {

            Spacer()

            Text("App is up to date")
                .viewTitle()

            Text(titleText)
                .viewDescription()

            Spacer()

            if isUpdateAvailable {
                PrimaryButton(label: "Update now") {
                    viewModel.appUpdateTapped()
                }
            } else {
                PrimaryButton(label: "Add an asset") {
                    viewModel.addAssetTapped()
                }
            }

        }.padding(20)
    }
}

private extension AppInfoView {

    var titleText: String {
        if let availableVersion = availableVersion {
            return "App update available: \(availableVersion)\nCurrent version: \(currentVersion)"
        }
        return "Current version: \(currentVersion)"
    }

    var isUpdateAvailable: Bool {
        availableVersion != nil
    }

    var currentVersion: String {
        switch viewModel.viewState {
        case let .appUpToDate(currentVersion), let .appUpdateAvailable(currentVersion, _):
            return currentVersion
        }
    }

    var availableVersion: String? {
        if case let .appUpdateAvailable(_, availableVersion) = viewModel.viewState {
            return availableVersion
        }
        return nil
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let viewState = AppInfoViewState.appUpToDate(currentVersion: "0.9")
        let viewModel = PreviewAppInfoViewModel(state: viewState)
        return AppInfoView(viewModel: viewModel)
    }
}
