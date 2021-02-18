//
//  ReportVerificationTests.swift
//  UsingTengizReportSPTests
//
//  Created by Igor Malyarov on 15.02.2021.
//

import XCTest
import Model
import TextReports
@testable import Verification

final class ReportVerificationTests: XCTestCase {
    func testTokenization() throws {
        for filename in ContentLoader.allFilenames {
            let contents = try ContentLoader.contentsOfFile(filename)
            XCTAssertFalse(try ContentLoader.contentsOfFile(filename).isEmpty, "Can't read Report file content")
            _ = try TokenizedReport(stringLiteral: contents).report().get()
        }

    }

    func testAllReportsVerification() throws {
        for filename in ContentLoader.allFilenames {
            let contents = try ContentLoader.contentsOfFile(filename)
            let report = try TokenizedReport(stringLiteral: contents).report().get()

            let reportID = "\(report.company) \(report.monthStr):\n"

            XCTAssert(report.isTotalExpensesMatch, "\(reportID)Recorded (\(report.totalExpenses)) and calculated sum of groups' total expenses (\(report.calculatedTotalExpenses)) should be equal, but they differ by \(report.totalExpensesDelta)")

            XCTAssert(report.isBalanceOk, "\(reportID)Total balance (\(report.balance)) should be equal to revenue minus total expenses (\(report.revenue - report.totalExpenses)), but the difference is \(report.runningBalanceDelta)")

            XCTAssert(report.isRunningBalanceOk, "\(reportID)Running balance (\(report.runningBalance)) should be equal to opening balance plus balance (\(report.openingBalance + report.balance)), but the difference is \(report.balanceDelta)")

            XCTAssert(report.isGroupAmountsMatch, "\(reportID)At least one Group with amount mismatch.")
            for group in report.groups {
                XCTAssert(group.isAmountMatch, "\(reportID)Group '\(group.title)' amount (\(group.amount)) and sum of items amount (\(group.amountCalculated)) should be equal, but they differ by \(group.amountDelta)")
            }
        }
    }

}


