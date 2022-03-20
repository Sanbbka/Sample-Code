//
//  SoftPosViewControllerTests.swift
//  DigitalSalesTests
//
//  Created by Alexander Drovnyashin on 18.02.2022.
//
//

import XCTest
import SOLIDArch
import DSKit
import SMBCore
import PSBCore

/// Тест [класса](x-source-tag://DigitalSales.SoftPosLandingViewController)
/// - Tag: DigitalSales.SoftPosLandingViewControllerTests
class SoftPosLandingViewControllerTests: XCTestCase {

    func testThatViewControllerRespondToChipsAction() {
        // arrange
        let vc = SoftPosLandingViewController(
            landingTableVC: NATableViewController(),
            diffableObserver: nil
        )

        let vm = SoftPosLandingVMMock()

        XCTAssertFalse(vm.buildSectionsValue)

        vc.viewModel = vm
        let chips = ChipsView()
        let chipsVM = ChipsViewModel(selectionEnabled: true,
                                     multipleSelection: false,
                                     items: [],
                                     selectedIndexes: [30])
        chips.viewModel = chipsVM

        // act
        vc.chipsViewDidTapTag(chips)

        // assert
        XCTAssertTrue(vm.buildSectionsValue)
    }

    func testThatSliderValueChangeViewModelCorrectly() {
        // arrange
        let vc = SoftPosLandingViewController(
            landingTableVC: NATableViewController(),
            diffableObserver: nil
        )

        let vm = SoftPosLandingVMMock()
        let slider = DSSlider()
        slider.minimumValue = 0
        slider.maximumValue = 600
        slider.value = 400
        vc.viewModel = vm
        vc.viewDidLoad()

        // act
        vc.sliderValueDidChanged(slider)

        // assert
        XCTAssertEqual(vm.sliderValue, 400)
    }
}

private final class SoftPosLandingVMMock: SoftPosViewModelProtocol {
    var softPosDataController: SoftPosDataControllerProtocol = SoftPosDataControllerStub()
    var buildSectionsValue = false
    var sliderValue = 0

    func buildSections() {
        buildSectionsValue = true
    }

    func sliderCellDidChangeValue(value: Int) -> Int {
        sliderValue = value

        return value
    }
}
