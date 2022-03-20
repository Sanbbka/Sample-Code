//
//  SoftPosSecondStepViewModelTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 22.02.2022.
//
//

import XCTest
import Common

/// Тест [класса](x-source-tag://DigitalSales.SoftPosSecondStepViewModel)
/// - Tag: DigitalSales.SoftPosSecondStepViewModelTests
class SoftPosSecondStepViewModelTests: XCTestCase {

    func testValueSuccessTitleWithSignAndExecutor() {
        // arrange
        let vm = makeViewModel(permission: makeSignAndExecutor())

        // act
        let value = vm.successTitle

        // assert
        XCTAssertEqual(value, "Заявка отправлена")
    }

    func testValueSuccessTitleWithSign() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        let value = vm.successTitle

        // assert
        XCTAssertEqual(value, "Заявка сохранена")
    }

    func testValueSuccessDetailWithSignAndExecutor() {
        // arrange
        let vm = makeViewModel(permission: makeSignAndExecutor())

        // act
        let value = vm.successDetail

        // assert
        XCTAssertEqual(value, "Мы перезвоним в течение\nдня по номеру ")
    }

    func testValueSuccessDetailWithSign() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        let value = vm.successDetail

        // assert
        XCTAssertEqual(value, "Теперь руководитель может отправить заявку в банк из раздела «Документы»")
    }

    func testValueErrorTitleWithSignAndExecutor() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        let value = vm.successDetail

        // assert
        XCTAssertEqual(value, "Теперь руководитель может отправить заявку в банк из раздела «Документы»")
    }

    func testValueErrorTitleWithSign() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        let value = vm.successDetail

        // assert
        XCTAssertEqual(value, "Теперь руководитель может отправить заявку в банк из раздела «Документы»")
    }

    func testValueErrorDetail() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // assert
        XCTAssertEqual(vm.errorDetail, "Что-то пошло не так. Попробуйте повторить позже.")
    }

    func testValueNavigationViewModel() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        let navigationVM = vm.navigationViewModel

        // assert
        XCTAssertEqual(navigationVM.title, "Оформление заявки")
        XCTAssertEqual(navigationVM.subtitle, "Шаг 2 из 2")
    }

    func testThatSelectedAccountIndexChangeInToDataController() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        vm.selectedAccountIndex = 3

        // assert
        XCTAssertEqual(vm.softPosDataController.selectedAccountIndex, 3)
        XCTAssertEqual(vm.selectedAccountIndex, 3)
    }

    func testThatViewModelSelectFieldActivityAndDataControllerUpdated() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        vm.selectFieldActivity(title: "testMcc")

        // assert
        XCTAssertEqual(vm.result.fieldOfActivity.text, "testMcc")
    }

    func testThatUpdateCompanyNameFieldAndResultUpdatesNext() {
        // arrange
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        vm.updateCompanyNameField(text: "Название компании")

        // assert
        XCTAssertEqual(vm.result.companyName.text, "Название компании")
    }

    func testUpdateLatinCompanyNameField() {
        let vm = makeViewModel(permission: makeSignPermission())

        // act
        vm.updateLatinCompanyNameField(text: "NameLatin")

        // assert
        XCTAssertEqual(vm.result.multilineCompanyNameEn.text, "NameLatin")
    }

    func testThatAfterSendOfferDataCallSuccessBlock() {
        // arrange
        let vm = makeViewModel(permission: makeExucurorPermission())
        var success = false

        // act
        vm.successBlock = {
            success = true
        }
        vm.result.multilineCompanyNameEn.text = "asd"
        vm.result.companyName.text = "выаав"
        vm.result.fieldOfActivity.text = "тестт"
        vm.result.numberOfEmployees.text = "3"
        vm.result.email.text = "asd@sdd.ff"
        vm.result.address.text = "213dddd"
        vm.result.fullName.text = "fio"
        vm.result.phoneNumber.text = "+7 (333) 333-33-33"

        vm.sendOfferData()

        // assert
        XCTAssertTrue(success)
    }
}

private extension SoftPosSecondStepViewModelTests {
    func makeViewModel(permission: Permission) -> SoftPosSecondStepViewModel {
        SoftPosSecondStepViewModel(
            tableViewModel: LandingTableViewModel(),
            builderFactory: SmartBetLandingBuilderFactory(),
            softPosDataController: SoftPosDataControllerStub(),
            documentProvider: DocumentSigningProviderMock(),
            provider: SuccessAcquiringProviderMock(),
            permission: permission,
            cyrillicCompanyNameValidator: CyrillicCompanyNameValidator()
        )
    }
}

private func makeSignAndExecutor() -> Permission {
    Permission(
        data:
            [
                "Executor": true,
                "FirstSign": true,
                "SecondSign": true
            ]
    )
}

private func makeSignPermission() -> Permission {
    Permission(
        data:
            [
                "FirstSign": true
            ]
    )
}

private func makeExucurorPermission() -> Permission {
    Permission(
        data:
            [
                "Executor": true
            ]
    )
}
