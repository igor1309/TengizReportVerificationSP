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
        var filename: String

        filename = "Саперави АМ 2020-06"
        filename = "Саперави АМ 2020-07"
        filename = "Саперави АМ август 2020"
        filename = "Саперави АМ сентябрь 2020 "
        filename = "Саперави октябрь"
        filename = "Саперави АМ ноябрь 2020 "
        filename = "Саперави АМ декабрь 2020 "
        filename = "Саперави АМ январь 2021 "
        filename = "ВМ ЩК ноябрь 2020"
        filename = "ВМ ЩК декабрь 2020"
        filename = "ВМ ЩК январь 2021"

        let contents = try ContentLoader.contentsOfFile(filename)
        XCTAssertFalse(try ContentLoader.contentsOfFile(filename).isEmpty, "Can't read Report file content")
        _ = try TokenizedReport(stringLiteral: contents).report().get()

    }

    func testAllReportsVerification() throws {
        for filename in ContentLoader.allFilenames {
            let contents = try ContentLoader.contentsOfFile(filename)
            let report = try TokenizedReport(stringLiteral: contents).report().get()

            let reportID = "\(report.company) \(report.monthStr):\n"

            XCTAssert(report.isTotalExpensesMatch, "\(reportID)Recorded (\(report.totalExpenses)) and calculated sum of groups' total expenses (\(report.calculatedTotalExpenses)) should be equal, but they differ by \(report.totalExpensesDelta)")

            XCTAssert(report.isTotalOk, "\(reportID)Total balance (\(report.balance)) should be equal to revenue minus total expenses (\(report.revenue - report.totalExpenses)), but the difference is \(report.totalDelta)")

            XCTAssert(report.isBalanceOk, "\(reportID)Running balance (\(report.runningBalance)) should be equal to opening balance plus balance (\(report.openingBalance + report.balance)), but the difference is \(report.balanceDelta)")

            for group in report.groups {
                XCTAssert(group.isAmountMatch, "\(reportID)Group '\(group.title)' amount (\(group.amount)) and sum of items amount (\(group.amountCalculated)) should be equal, but they differ by \(group.amountDelta)")
            }
        }
    }

}


