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
        let delta = totalExpenses - calculatedTotalExpenses
        return abs(delta) < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isTotalExpensesMatch: Bool { totalExpensesDelta == 0 }

    public var calculatedBalance: Double {
        revenue - calculatedTotalExpenses
    }
    public var balanceDelta: Double {
        let delta = calculatedBalance - balance
        return abs(delta) < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isBalanceOk: Bool { balanceDelta == 0 }

    public var calculatedRunningBalance: Double {
        openingBalance + calculatedBalance
    }
    public var runningBalanceDelta: Double {
        let delta = calculatedRunningBalance - runningBalance
        return abs(delta) < TokenizedReport.Report.threshold ? 0 : delta
    }
    public var isRunningBalanceOk: Bool { runningBalanceDelta == 0 }

    public var isGroupAmountsMatch: Bool {
        groups.reduce(true, { $0 && $1.isAmountMatch })
    }
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
