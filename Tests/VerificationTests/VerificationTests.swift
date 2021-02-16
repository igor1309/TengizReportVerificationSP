//
//  VerificationTests.swift
//  UsingTengizReportSPTests
//
//  Created by Igor Malyarov on 16.02.2021.
//

import XCTest
import Model
@testable import Verification

final class VerificationTests: XCTestCase {
    func test_IsTotalOk() {
        let revenue: Double = 1_000_000
        var balance: Double = -200_000
        var totalExpenses: Double = 1_200_000
        var report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30_000, openingBalance: -100_000, balance: balance, runningBalance: -300_000, totalExpenses: totalExpenses, groups: [])
        XCTAssert(report.isTotalOk, "balance should be equal to revenue - totalExpenses")

        balance = 0
        totalExpenses = 1_000_000
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30_000, openingBalance: -100_000, balance: balance, runningBalance: -300_000, totalExpenses: totalExpenses, groups: [])
        XCTAssert(report.isTotalOk, "balance should be equal to revenue - totalExpenses")

        balance = 1
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30_000, openingBalance: -100_000, balance: balance, runningBalance: -300_000, totalExpenses: totalExpenses, groups: [])
        XCTAssertFalse(report.isTotalOk, "balance should be equal to revenue - totalExpenses")
    }

    func test_IsBalanceOk() {
        var openingBalance: Double = -100_000
        var balance: Double = -200_000
        var runningBalance: Double = -300_000
        var report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: openingBalance, balance: balance, runningBalance: runningBalance, totalExpenses: 1_200_000, groups: [])
        XCTAssert(report.isBalanceOk, "runningBalance should be equal to openingBalance + balance")
        XCTAssertEqual(report.runningBalance, report.openingBalance + report.balance, "runningBalance should be equal to openingBalance + balance")

        openingBalance = -100_000
        balance = 0
        runningBalance = -300_000
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: openingBalance, balance: balance, runningBalance: runningBalance, totalExpenses: 1_100_000, groups: [])
        XCTAssertFalse(report.isBalanceOk, "runningBalance should be equal to openingBalance + balance")
        XCTAssertNotEqual(report.runningBalance, report.openingBalance + report.balance, "runningBalance should be equal to openingBalance + balance")
    }

    func test_totalExpensesDelta() {
        var totalExpenses: Double = 1_200_000
        var groupAmount: Double = 1_200_000
        let itemAmount: Double = 1_200_000
        var report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: -100_000, balance: -200_000, runningBalance: -300_000, totalExpenses: totalExpenses,
            groups: [TokenizedReport.Report.Group(
                groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
                items: [TokenizedReport.Report.Group.Item(
                            itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
            )]
        )
        XCTAssertEqual(report.totalExpensesDelta, 0)
        XCTAssert(report.isTotalExpensesMatch)

        // Below threshold
        totalExpenses = 1_200_000
        groupAmount = 1_200_000 + TokenizedReport.Report.threshold / 2
        report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: -100_000, balance: -200_000, runningBalance: -300_000, totalExpenses: totalExpenses,
            groups: [TokenizedReport.Report.Group(
                groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
                items: [TokenizedReport.Report.Group.Item(
                            itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
            )]
        )
        XCTAssertEqual(report.totalExpensesDelta, 0, "Below threshold")
        XCTAssert(report.isTotalExpensesMatch, "Below threshold")

        // Above threshold
        totalExpenses = 1_200_000
        groupAmount = 1_200_000 + TokenizedReport.Report.threshold
        report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: -100_000, balance: -200_000, runningBalance: -300_000, totalExpenses: totalExpenses,
            groups: [TokenizedReport.Report.Group(
                groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
                items: [TokenizedReport.Report.Group.Item(
                            itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
            )]
        )
        XCTAssertNotEqual(report.totalExpensesDelta, 0, "Above threshold")
        XCTAssertFalse(report.isTotalExpensesMatch, "Above threshold")
    }

    func testGroupAmount() {
        var groupAmount: Double = 100
        var itemAmount: Double = 100
        var group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
        )
        XCTAssertEqual(group.amountCalculated, group.amount)
        XCTAssertEqual(group.amountDelta, 0)
        XCTAssert(group.isAmountMatch)

        groupAmount = 100
        itemAmount = 200
        group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
        )
        XCTAssertNotEqual(group.amountCalculated, group.amount)
        XCTAssertEqual(group.amountDelta, abs(groupAmount - itemAmount))
        XCTAssertFalse(group.isAmountMatch)

        // Below threshold
        groupAmount = 100
        itemAmount = 100 + TokenizedReport.Report.threshold / 2
        group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
        )
        XCTAssertNotEqual(group.amountCalculated, group.amount)
        XCTAssertNotEqual(group.amountDelta, groupAmount - itemAmount)
        XCTAssertEqual(group.amountDelta, 0, "Below threshold")
        XCTAssert(group.isAmountMatch, "Below threshold")

        // Above threshold
        itemAmount = 100 + TokenizedReport.Report.threshold * 2
        group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: groupAmount, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: itemAmount, note: nil)]
        )
        XCTAssertNotEqual(group.amountCalculated, group.amount)
        XCTAssertNotEqual(group.amountDelta, groupAmount - itemAmount)
        XCTAssertNotEqual(group.amountDelta, 0, "Above threshold")
        XCTAssertFalse(group.isAmountMatch, "Above threshold")

    }

}
