//
//  SoftPosSecondStepViewControllerTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 21.02.2022.
//
//

import XCTest
import UIKit
import SOLIDArch
import DSKit
import Signing
import Common
import Confirmation
import SMBCore

/// Тест [класса](x-source-tag://DigitalSales.SoftPosSecondStepViewController)
/// - Tag: DigitalSales.SoftPosSecondStepViewControllerTests
class SoftPosSecondStepViewControllerTests: XCTestCase {

    private let viewController = SoftPosSecondStepViewController(landingTableVC: NATableViewController())
    private let viewModel = SoftPosSecondStepViewModelMock()

    override func setUp() {
        viewController.viewModel = viewModel
    }

    func testThatSetupSetNavigationTitleText() {
        viewController.viewDidLoad()
        guard let titleView = viewController.navigationItem.titleView as? NavigationTitleView else {
            XCTFail()
            return
        }

        let titleMirror = NavigationTitleViewMirror(reflecting: titleView)

        let title = titleMirror.titleLabel?.attrText
        let subtitle = titleMirror.subtitleLabel?.attrText

        // assert
        XCTAssertEqual(title, "title")
        XCTAssertEqual(subtitle, "subtitle")
    }

    func testThatDidTapBottomButtonThenSendOfferData() {
        // arrange
        var isSendData = false
        viewModel.sendOfferDataBlock = {
            isSendData = true
        }

        // act
        viewController.didTapBottomButton()

        // assert
        XCTAssertTrue(isSendData)
    }

    func testThatDidTapFieldActifityThenOpenSearchScreen() {
        // arrange
        let navigation = NavigationMock(rootViewController: viewController)

        // act
        viewController.didTapFieldOfActivity()

        // assert
        let searchVC = navigation.presentedVC
        XCTAssertNotNil(searchVC)
    }

    func testThatDataSendSuccesThenSuccessAlertShow() {
        // arrange
        let navigation = NavigationMock(rootViewController: viewController)

        // act
        viewModel.successBlock?()

        // assert
        let alertVC = navigation.presentedVC as? SimpleRecipeAlert
        XCTAssertNotNil(alertVC)
    }

    func testThatDataSendFailedThenErrorAlertShow() {
        // arrange
        let navigation = NavigationMock(rootViewController: viewController)

        // act
        viewModel.failureBlock?()

        // assert
        let alertVC = navigation.presentedVC as? SimpleRecipeAlert
        XCTAssertNotNil(alertVC)
    }

    func testThatDidTapSelectAccountThenOpenAccountSelectVC() {
        // arrange
        let navigation = NavigationMock(rootViewController: viewController)

        // act
        viewController.didTapSelectAccount()

        // assert
        let offerVC = navigation.presentedVC as? AccountSelectViewController
        XCTAssertNotNil(offerVC)
    }

    func testThatLatinTextFieldDidChanged() {
        // arrange
        var isUpdateLatinTextField = false
        viewModel.updateLatinCompanyNameFieldBlock = {
            isUpdateLatinTextField = true
        }
        let textField = MultilineField()
        textField.viewModel = MultilineFieldVM(
            text: "test1",
            identifier: SoftPosSecondStep.Cell.LatinFieldName.id
        )

        // act
        viewController.textDidChanged(textField)

        // assert
        XCTAssertTrue(isUpdateLatinTextField)
    }

    func testThatCompanyTextFieldDidChanged() {
        // arrange
        var isUpdateLatinTextField = false
        viewModel.updateCompanyNameFieldBlock = {
            isUpdateLatinTextField = true
        }
        let textField = MultilineField()
        textField.viewModel = MultilineFieldVM(
            text: "test1"
        )

        // act
        viewController.textDidChanged(textField)

        // assert
        XCTAssertTrue(isUpdateLatinTextField)
    }

    func testThatCompanyTextFieldDidEndEditing() {
        // arrange
        var isUpdateLatinTextField = false
        viewModel.updateCompanyNameFieldBlock = {
            isUpdateLatinTextField = true
        }
        let textField = MultilineField()
        textField.viewModel = MultilineFieldVM(
            text: "test1"
        )

        // act
        viewController.didEndEditing(textField)

        // assert
        XCTAssertTrue(isUpdateLatinTextField)
    }

    func testConfigurationAnimationControllerForPresenting() {
        // act
        guard let transition = viewController.animationController(
            forPresented: viewController,
            presenting: UIViewController(),
            source: UIViewController()
        ) as? PopAnimator else {
            XCTFail()
            return
        }

        // assert
        XCTAssertTrue(transition.presenting)
    }

    func testConfigurationAnimationComtrollerForDismissed() {
        // act
        guard let transition = viewController.animationController(
                forDismissed: UIViewController()
        ) as? PopAnimator else {
            XCTFail()
            return
        }

        // assert
        XCTAssertFalse(transition.presenting)
    }
}

private final class SoftPosSecondStepViewModelMock: SoftPosSecondStepViewModelProtocol {

    var successBlock: Closure?
    var failureBlock: Closure?
    var loadingBlock: ObjectClosure<Bool>?
    var invalidItemBlock: ObjectClosure<IndexPath>?
    var confirmationBlock: ((PSBBaseConfirmationInteractor, ConfirmMessageInfoProtocol) -> Void)?

    var successTitle: String = ""

    var successDetail: String = ""

    var errorTitle: String = ""

    var errorDetail: String = ""

    var selectedAccountIndex: Int = 0

    var accounts: [PSBAccount] = []

    var activitesVM: [BaseTitleAndSubtitleCellVM] = []

    var navigationViewModel: SubtitlableViewModelProtocol {
        TitleAndSubtitleVM(
            title: "title",
            subtitle: "subtitle"
        )
    }

    var sendOfferDataBlock: Closure?
    var updateCompanyNameFieldBlock: Closure?
    var updateLatinCompanyNameFieldBlock: Closure?

    func reloadData() {

    }

    func sendOfferData() {
        sendOfferDataBlock?()
    }

    func selectFieldActivity(title: String) {

    }

    func updateCompanyNameField(text: String?) {
        updateCompanyNameFieldBlock?()
    }

    func updateLatinCompanyNameField(text: String?) {
        updateLatinCompanyNameFieldBlock?()
    }
}
