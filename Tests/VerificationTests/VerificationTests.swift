//
//  VerificationTests.swift
//  UsingTengizReportSPTests
//
//  Created by Igor Malyarov on 16.02.2021.
//

import XCTest
import TengizReportModel
@testable import Verification

final class VerificationTests: XCTestCase {
    func test_isBalanceOk() {
        let revenue: Double = 1_000
        var balance: Double = 1_000
        var totalExpenses: Double = 1_200
        var report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30, openingBalance: -100, balance: balance, runningBalance: -300, totalExpenses: totalExpenses, groups: [])
        XCTAssertEqual(report.calculatedBalance, 1_000)
        XCTAssertEqual(report.calculatedTotalExpenses, 0)
        XCTAssertEqual(report.revenue - report.calculatedTotalExpenses, 1_000)
        XCTAssertEqual(report.calculatedBalance, report.balance)
        XCTAssert(report.isBalanceOk, "calculatedBalance should be equal to balance")

        balance = -200
        totalExpenses = 1_200
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30, openingBalance: -100, balance: balance, runningBalance: -300, totalExpenses: totalExpenses, groups: [])
        XCTAssertEqual(report.calculatedBalance, 1_000)
        XCTAssertEqual(report.calculatedTotalExpenses, 0)
        XCTAssertEqual(report.revenue - report.calculatedTotalExpenses, 1_000)
        XCTAssertNotEqual(report.calculatedBalance, report.balance)
        XCTAssertFalse(report.isBalanceOk, "calculatedBalance should be equal to balance")

        balance = 0
        totalExpenses = 1
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30, openingBalance: -100, balance: balance, runningBalance: -300, totalExpenses: totalExpenses, groups: [])
        XCTAssertEqual(report.calculatedBalance, 1_000)
        XCTAssertEqual(report.calculatedTotalExpenses, 0)
        XCTAssertEqual(report.revenue - report.calculatedTotalExpenses, 1_000)
        XCTAssertNotEqual(report.calculatedBalance, report.balance)
        XCTAssertFalse(report.isBalanceOk, "calculatedBalance should be equal to balance")

        balance = 1
        report = TokenizedReport.Report(monthStr: "", month: 1, year: 2021, company: "Company", revenue: revenue, dailyAverage: 30, openingBalance: -100, balance: balance, runningBalance: -300, totalExpenses: totalExpenses, groups: [])
        XCTAssertEqual(report.calculatedBalance, 1_000)
        XCTAssertEqual(report.calculatedTotalExpenses, 0)
        XCTAssertEqual(report.revenue - report.calculatedTotalExpenses, 1_000)
        XCTAssertNotEqual(report.calculatedBalance, report.balance)
        XCTAssertFalse(report.isBalanceOk, "calculatedBalance should be equal to balance")
    }

    func test_isRunningBalanceOk() {
        var openingBalance: Double = -100
        var balance: Double = -200
        var runningBalance: Double = 200
        var report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000, dailyAverage: 30, openingBalance: openingBalance, balance: balance, runningBalance: runningBalance, totalExpenses: 1_200,
            groups: [TokenizedReport.Report.Group(
                groupNumber: 0, title: "Group", amount: 700, target: nil,
                items: [TokenizedReport.Report.Group.Item(itemNumber: 1, title: "Item", amount: 700, note: nil)]
            )]
        )
        XCTAssertEqual(report.calculatedBalance, 300)
        XCTAssertEqual(report.calculatedRunningBalance, 200)
        XCTAssert(report.isRunningBalanceOk, "runningBalance should be equal to openingBalance + balance")
        XCTAssertEqual(report.calculatedRunningBalance, report.openingBalance + report.calculatedBalance, "calculatedRunningBalance should be equal to openingBalance + calculatedBalance")

        openingBalance = -100
        balance = -200
        runningBalance = -300
        report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000, dailyAverage: 30, openingBalance: openingBalance, balance: balance, runningBalance: runningBalance, totalExpenses: 1_200,
            groups: [TokenizedReport.Report.Group(
                groupNumber: 0, title: "Group", amount: 700, target: nil,
                items: [TokenizedReport.Report.Group.Item(itemNumber: 1, title: "Item", amount: 700, note: nil)]
            )]
        )
        XCTAssertEqual(report.calculatedBalance, 300)
        XCTAssertEqual(report.calculatedRunningBalance, 200)
        XCTAssertFalse(report.isRunningBalanceOk, "runningBalance should be equal to openingBalance + balance")
        XCTAssertEqual(report.calculatedRunningBalance, report.openingBalance + report.calculatedBalance, "calculatedRunningBalance should be equal to openingBalance + calculatedBalance")
    }

    func test_isTotalExpensesMatch() {
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

    func test_isGroupAmountsMatch() {
        // true
        let group1 = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: 100, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil),
                    TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil)]
        )
        XCTAssert(group1.isAmountMatch)

        // false
        let group2 = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: 100, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil)]
        )
        XCTAssertFalse(group2.isAmountMatch)

        var report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: -100_000, balance: -200_000, runningBalance: -300_000, totalExpenses: 1_200_000,
            groups: [group1]
        )
        XCTAssert(report.isGroupAmountsMatch)

        report = TokenizedReport.Report(
            monthStr: "", month: 1, year: 2021, company: "Company", revenue: 1_000_000, dailyAverage: 30_000, openingBalance: -100_000, balance: -200_000, runningBalance: -300_000, totalExpenses: 1_200_000,
            groups: [group1, group2]
        )
        XCTAssertFalse(report.isGroupAmountsMatch)
    }

    func test_isAmountMatch() {
        // true
        var group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: 100, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil),
                    TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil)]
        )
        XCTAssert(group.isAmountMatch)

        // false
        group = TokenizedReport.Report.Group(
            groupNumber: 1, title: "Group", amount: 100, target: 0.25,
            items: [TokenizedReport.Report.Group.Item(
                        itemNumber: 1, title: "Item", amount: 50, note: nil)]
        )
        XCTAssertFalse(group.isAmountMatch)
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
