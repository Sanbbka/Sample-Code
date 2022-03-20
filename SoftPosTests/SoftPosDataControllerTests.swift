//
//  SoftPosDataControllerTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 24.02.2022.
//
//

import XCTest

/// Тест [класса](x-source-tag://DigitalSales.SoftPosDataController)
/// - Tag: DigitalSales.SoftPosDataControllerTests
class SoftPosDataControllerTests: XCTestCase {

    func testThatIsOnePercentTariffHasPercentValueEqualOne() {
        // arrange
        let vm = makeDataController(isOnePercentTarification: true)

        // assert
        XCTAssertEqual(vm.tariffPercent, "1")
    }

    func testThatTariffPercentEqualMinCommissionPercent() {
        // arrange
        let vm = makeDataController(isOnePercentTarification: false)

        // assert
        XCTAssertEqual(vm.tariffPercent, "2")
    }

    func testThatTerminalHasCountFrom_1_to_1000_terminals() {
        // arrange
        let vm = makeDataController()

        // act
        // assert
        let validValues = [
            1,
            400,
            1000
        ]

        let invalidValues = [
            0,
            1001,
            -1
        ]

        invalidValues.forEach { item in
            vm.terminalCount = item
            XCTAssertEqual(vm.terminalCount, 1)
        }

        validValues.forEach { item in
            vm.terminalCount = item
            XCTAssertEqual(vm.terminalCount, item)
        }
    }

    func testThatDataControllerFillAndCreateDataModelUpdate() {
        // arrange
        let vm = makeDataController()
        let secondStep = vm.secondStep
        secondStep.email.text = "ww@ww.com"
        secondStep.companyName.text = "наименование"
        secondStep.multilineCompanyNameEn.text = "name"
        secondStep.address.text = "Скеллиге"
        secondStep.fullName.text = "Геральт"
        vm.terminalCount = 3

        // act
        vm.fillViewModel()

        // assert
        XCTAssertEqual(vm.softPosViewModel.notificationEmail, "ww@ww.com")
        XCTAssertEqual(vm.softPosViewModel.tradePointNameRus, "наименование")
        XCTAssertEqual(vm.softPosViewModel.tradePointNameLat, "name")
        XCTAssertEqual(vm.softPosViewModel.tradePointAddress, "Скеллиге")
        XCTAssertEqual(vm.softPosViewModel.tradePointContactFullName, "Геральт")
        XCTAssertEqual(vm.softPosViewModel.terminalCount, 3)
    }

    func testThatEnableSupportQps() {
        // arrange
        let vm = makeDataController()

        // act
        vm.supportQpsToggle(isOn: true)

        // assert
        XCTAssertTrue(vm.softPosViewModel.supportQps)
    }

    func testThatEnableSupportFrequentTransferToggle() {
        // arrange
        let vm = makeDataController()

        // act
        vm.supportFrequentTransferToggle(isOn: true)

        // assert
        XCTAssertTrue(vm.softPosViewModel.supportFrequentTransfer)
    }

    func testThatEnableSupportCashRegisterToggle() {
        // arrange
        let vm = makeDataController()

        // act
        vm.supportCashRegisterToggle(isOn: true)

        // assert
        XCTAssertTrue(vm.softPosViewModel.supportMobileCashRegister)
    }

    func testThatEnableSupportPayLinkToggle() {
        // arrange
        let vm = makeDataController()

        // act
        vm.supportPayLinkToggle(isOn: true)

        // assert
        XCTAssertTrue(vm.softPosViewModel.supportPayLink)
    }

    func testThatSelectActivity() {
        // arrange
        let vm = makeDataController()

        // act
        vm.selectFieldOfActivity(
            mcc: .init(
                mcc: 3,
                name: "nameTest",
                groupName: "group",
                minCommissionPercent: 2,
                maxCommissionPercent: 10,
                qpsCommissionPercent: 5
            )
        )

        // assert
        XCTAssertEqual(vm.softPosViewModel.mcc, 3)
    }
}

private extension SoftPosDataControllerTests {
    func makeDataController(
        isOnePercentTarification: Bool = false
    ) -> SoftPosDataController {
        let data = SoftPosData(
            commissionGroupTurnover: .init(
                isOnePercentTarification: isOnePercentTarification,
                minCommissionPercent: 2,
                mccGroups: []
            ),
            limits: .init(min: 1, max: 2),
            frequentTransferCost: .init(frequentTransferCostItems: []),
            softPosCommission: .init(isOnePercentTarification: isOnePercentTarification,
                                     mcc: []),
            userAccounts: [],
            clientRequisistes: ClientRequisites.invalidateMock
        )

        return SoftPosDataController(
            softPosData: data,
            accounts: [],
            userEmail: nil
        )
    }
}
