//
//  SoftPosFirstStepViewModelTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 26.01.2022.
//
//

import XCTest
import SOLIDArch
import PSBCore
import DSKit
import SMBCore

/// Тест [класса](x-source-tag://DigitalSales.SoftPosFirstStepViewModelTests)
/// - Tag: DigitalSales.SoftPosFirstStepViewModelTests
class SoftPosFirstStepViewModelTests: XCTestCase {

    private let dataController = SoftPosDataControllerMock()

    private lazy var viewModel = SoftPosFirstStepViewModel(
        tableViewModel: LandingTableViewModelMock(),
        builderFactory: SmartBetLandingBuilderFactory(),
        softPosDataController: dataController
    )

    func testThatViewModelHasNavigationModelForFirstStep() {
        // arrange
        // act
        // assert
        XCTAssertEqual(viewModel.navigationViewModel.title, "Оформление заявки")
        XCTAssertEqual(viewModel.navigationViewModel.subtitle, "Шаг 1 из 2")
    }

    func testThatViewModelUpdatedTerminalCount() {
        // arrange
        // act
        viewModel.updateTerminal(count: 4)
        viewModel.reloadData()

        // assert
        XCTAssertEqual(dataController.terminalCount, 4)
    }
}

private final class LandingTableViewModelMock: LandingTableViewModelProtocol {
    func update(sections: [NASectionInfo]) {}
}

private final class SoftPosDataControllerMock: SoftPosDataControllerProtocol {
    var tariffPercent = "2"

    var isOnePercentTarification = false

    var secondStep = SecondStepResult()

    var selectedAccount: PSBAccount?

    var accounts: [PSBAccount] = []

    var softPosData = SoftPosData(
        commissionGroupTurnover: .init(isOnePercentTarification: false, minCommissionPercent: 3, mccGroups: []),
        limits: .init(min: 0, max: 2),
        frequentTransferCost: .init(frequentTransferCostItems: []),
        softPosCommission: .init(isOnePercentTarification: false, mcc: []),
        userAccounts: [],
        clientRequisistes: .invalidateMock
    )

    var frequentTransferCost: String?

    var selectedAccountIndex = 0

    var softPosViewModel = AcquiringAppSoftPosCreateCommand()
    var landingFooterViewModel = SoftPosLandingFooterViewModel()
    var terminalCount = 0

    var qpsToggle = false
    var frequentTransferToggle = false
    var cashRegisterToggle = false
    var payLinkToggle = false

    func supportQpsToggle(isOn: Bool) {
        qpsToggle = isOn
    }

    func supportFrequentTransferToggle(isOn: Bool) {
        frequentTransferToggle = isOn
    }

    func supportCashRegisterToggle(isOn: Bool) {
        cashRegisterToggle = isOn
    }

    func supportPayLinkToggle(isOn: Bool) {
        payLinkToggle = isOn
    }

    func selectFieldOfActivity(mcc: SmartCommissionMCC) {

    }

    func fillViewModel() {

    }
}
