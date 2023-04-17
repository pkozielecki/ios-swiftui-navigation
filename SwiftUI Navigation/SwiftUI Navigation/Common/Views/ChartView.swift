//
//  ChartView.swift
//  KISS Views
//

import Charts
import SwiftUI

struct ChartView: View {
    let data: [ChartPoint]
    let xAxisName: String
    let yAxisName: String

    var body: some View {
        Chart(data) {
            LineMark(
                x: .value(xAxisName, $0.label),
                y: .value(yAxisName, $0.value)
            )
            PointMark(
                x: .value(xAxisName, $0.label),
                y: .value(yAxisName, $0.value)
            )
        }
    }
}

extension ChartView {

    /// A helper structure describing a point on a chart.
    struct ChartPoint: Identifiable {

        /// A point unique ID.
        var id = UUID()

        /// A point label on X axis.
        let label: String

        /// A point value.
        let value: Double
    }

    /// A helper enumeration describing a chart time scopes.
    enum Scope: String, CaseIterable {
        case day, week, month, quarter, year
    }
}
