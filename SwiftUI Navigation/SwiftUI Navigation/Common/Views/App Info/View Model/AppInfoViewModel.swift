//
//  AppInfoViewModel.swift
//  KISS Views
//

import Foundation
import SwiftUI

/// A view state for AppInfoView.
enum AppInfoViewState: Equatable {

    /// App is up to date.
    case appUpToDate(currentVersion: String)

    /// App update is available.
    case appUpdateAvailable(currentVersion: String, availableVersion: String)
}

/// An abstraction describing AppInfo view model.
protocol AppInfoViewModel: ObservableObject {
    /// A view state.
    var viewState: AppInfoViewState { get }
    var viewStatePublished: Published<AppInfoViewState> { get }
    var viewStatePublisher: Published<AppInfoViewState>.Publisher { get }

    /// Triggered when user taps on add asset button.
    func addAssetTapped()

    /// Triggered when user taps on app update button.
    func appUpdateTapped()
}
