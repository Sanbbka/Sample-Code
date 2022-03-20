//
//  SoftPosFirstStepViewControllerTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 26.01.2022.
//
//

import XCTest
import SOLIDArch
import DSKit
import PSBCore
import SMBCore

/// Тест [класса](x-source-tag://DigitalSales.SoftPosFirstStepViewController)
/// - Tag: DigitalSales.SoftPosFirstStepViewControllerTests
final class SoftPosFirstStepViewControllerTests: XCTestCase {

    private let viewController = SoftPosFirstStepViewController(landingTableVC: NATableViewController())
    private let viewModel = SoftPosFirstStepViewModelMock()

    override func setUp() {
        viewController.viewModel = viewModel
    }

    func testThatSetupSetNavigationTitleText() {
        // arrange
        let titleMirror = NavigationTitleViewMirror(reflecting: viewController.titleView)

        // act
        viewController.viewDidLoad()

        let title = titleMirror.titleLabel?.attrText
        let subtitle = titleMirror.subtitleLabel?.attrText

        // assert
        XCTAssertEqual(title, "Title")
        XCTAssertEqual(subtitle, "Subtitle")
    }

    func testThatSwitchValueChangeAndViewModelReloadData() {
        // arrange
        let switcher = Switch()

        // act
        viewController.switchValueDidChange(switcher)

        // assert
        XCTAssertTrue(viewModel.reloadDataCall)
    }

    func testThatStepperSendEventTapDecreaseAndViewModelGetIt() {
        // arrange
        let stepperView = StepperView()
        stepperView.viewModel = StepperViewModel(value: 10)

        // act
        viewController.stepperViewDidTapDecrease(stepperView)

        // assert
        XCTAssertEqual(viewModel.terminalCount, 9)
    }

    func testThatStepperSendEventTapIncreaseAndViewModelGetIt() {
        // arrange
        let stepperView = StepperView()
        stepperView.viewModel = StepperViewModel(value: 10)

        // act
        viewController.stepperViewDidTapIncrease(stepperView)

        // assert
        XCTAssertEqual(viewModel.terminalCount, 11)
    }

    func testThatStepperSendEventEnterTextAndViewModelGetIt() {
        // arrange
        let stepperView = StepperView()
        stepperView.viewModel = StepperViewModel(value: 10)
        _ = stepperView.textField(
            UITextField(),
            shouldChangeCharactersIn: NSRange(),
            replacementString: "5"
        )

        // act
        viewController.stepperViewDidEnterText(stepperView)

        // assert
        XCTAssertEqual(viewModel.terminalCount, 5)
    }
}

private final class SoftPosFirstStepViewModelMock: SoftPosFirstStepViewModelProtocol {
    var softPosDataController: SoftPosDataControllerProtocol = SoftPosDataControllerStub()

    var navigationViewModel: SubtitlableViewModelProtocol {
        TitleAndSubtitleVM(
            title: "Title",
            subtitle: "Subtitle"
        )
    }
    var reloadDataCall = false
    var terminalCount = 0

    func reloadData() {
        reloadDataCall = true
    }

    func updateTerminal(count: Int) {
        terminalCount = count
    }
}

final class NavigationTitleViewMirror: MirrorObject {
    var titleLabel: CustomLabel? {
        extract()
    }
    var subtitleLabel: CustomLabel? {
        extract()
    }
}

final class SoftPosDataControllerStub: SoftPosDataControllerProtocol {
    var tariffPercent: String = "2"

    var isOnePercentTarification: Bool = false

    var softPosViewModel = AcquiringAppSoftPosCreateCommand()

    var landingFooterViewModel = SoftPosLandingFooterViewModel()

    var secondStep = SecondStepResult()

    var selectedAccount: PSBAccount?

    var accounts: [PSBAccount] = []

    var softPosData = SoftPosData(
        commissionGroupTurnover: .init(isOnePercentTarification: false, minCommissionPercent: 3, mccGroups: []),
        limits: .init(min: 0, max: 2),
        frequentTransferCost: .init(frequentTransferCostItems: []),
        softPosCommission: .init(
            isOnePercentTarification: false,
            mcc: [
                .init(
                    mcc: 3,
                    name: "testMcc",
                    groupName: "name",
                    minCommissionPercent: 2,
                    maxCommissionPercent: 5,
                    qpsCommissionPercent: 4
                )
            ]
        ),
        userAccounts: [],
        clientRequisistes: .invalidateMock
    )

    var frequentTransferCost: String?

    var terminalCount: Int = 1

    var selectedAccountIndex: Int = 0

    func supportQpsToggle(isOn: Bool) {

    }

    func supportFrequentTransferToggle(isOn: Bool) {

    }

    func supportCashRegisterToggle(isOn: Bool) {

    }

    func supportPayLinkToggle(isOn: Bool) {

    }

    func selectFieldOfActivity(mcc: SmartCommissionMCC) {

    }

    func fillViewModel() {

    }
}
