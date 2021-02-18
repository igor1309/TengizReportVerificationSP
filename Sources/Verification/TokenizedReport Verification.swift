//
//  TokenizedReport Verification.swift
//  UsingTengizReportSP
//
//  Created by Igor Malyarov on 11.02.2021.
//

import Foundation
import Model

extension TokenizedReport.Report {
    static var threshold = 1e-5

    public var calculatedTotalExpenses: Double {
        groups.map(\.amount).reduce(0, +)
    }
    public var totalExpensesDelta: Double {
        let delta = abs(totalExpenses - calculatedTotalExpenses)
        return delta < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isTotalExpensesMatch: Bool { totalExpensesDelta == 0 }

    public var totalDelta: Double {
        let delta = abs((revenue - totalExpenses) - balance)
        return delta < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isTotalOk: Bool { totalDelta == 0 }

    public var balanceDelta: Double {
        let delta = abs(runningBalance - (openingBalance + balance))
        return delta < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isBalanceOk: Bool { balanceDelta == 0 }
}

extension TokenizedReport.Report.Group {
    public var amountCalculated: Double {
        items.map(\.amount).reduce(0, +)
    }
    public var amountDelta: Double {
        let delta = abs(amount - amountCalculated)
        return delta < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isAmountMatch: Bool { amountDelta == 0 }
}
