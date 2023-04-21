//
//  AssetDetailsView.swift
//  KISS Views
//

import SwiftUI

struct AssetDetailsView<ViewModel>: View where ViewModel: AssetDetailsViewModel {

    @StateObject var viewModel: ViewModel

    @State private var scope: String?

    var body: some View {

        List {
            Section {
                HStack {
                    //  Asset name label:
                    Text(assetData.name)
                        .viewTitle()

                    Spacer()

                    //  Edit asset button:
                    Button {
                        viewModel.edit(asset: assetData.id)
                    } label: {
                        Image(systemName: "pencil.line")
                    }
                }
            }

            Section {
                if let chartData {

                    //  Chart view:
                    // TODO: Fix date labels!
                    // TODO: Fix Y axis
                    ChartView(data: chartData, xAxisName: "Data", yAxisName: "Price")
                        .frame(height: 200)
                        .padding(.top, 10)

                    //  Chart scope selector:
                    Picker("", selection: .init(currentValue: $scope, initialValue: ChartView.Scope.week.rawValue)) {
                        ForEach(ChartView.Scope.allCases, id: \.rawValue) { scope in
                            Text("\(scope.rawValue)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)

                } else if let error {

                    VStack(spacing: 20) {
                        Spacer()

                        //  Error description:
                        Text(error)
                            .viewDescription()

                        Spacer()

                        //  Try again button:
                        PrimaryButton(label: "Try again?") {
                            print("try again?")
                        }

                        Spacer()
                    }

                } else {

                    //  A chart loader view:
                    LoaderView(configuration: .chartLoader)
                }
            }
        }
        .onChange(of: scope) { scope in
            if let scope, let chartScope = ChartView.Scope(rawValue: scope) {
                Task {
                    await viewModel.reloadChart(scope: chartScope)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.showInitialChart()
            }
        }
    }
}

private extension AssetDetailsView {

    var assetData: AssetDetailsViewData {
        viewModel.assetData
    }

    var chartData: [ChartView.ChartPoint]? {
        if case let .loaded(points) = viewModel.viewState {
            return points
        }
        return nil
    }

    var error: String? {
        if case let .failed(error) = viewModel.viewState {
            return error
        }
        return nil
    }
}

struct AssetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewState = AssetDetailsViewState.loading
//        let viewState = AssetDetailsViewState.loaded([
//            .init(label: "01/2023", value: 10123),
//            .init(label: "02/2023", value: 15000),
//            .init(label: "03/2023", value: 13000),
//            .init(label: "04/2023", value: 17000),
//            .init(label: "05/2023", value: 20000)
//        ])
//        let viewState = AssetDetailsViewState.failed("An unknown network error has occurred\nTry again later.")
        let viewModel = PreviewAssetDetailsViewModel(state: viewState)
        return AssetDetailsView(viewModel: viewModel)
    }
}
