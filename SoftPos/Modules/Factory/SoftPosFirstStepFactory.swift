//
//  SoftPosFirstStepFactory.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//

import SOLIDArch
import DSKit
import UIKit
import SMBCore
import PSBCore

/// Фабрика для первого шага `SoftPos`
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosFirstStepFactoryTests)
/// - Tag: DigitalSales.SoftPosFirstStepFactory
struct SoftPosFirstStepFactory {

    let softPosDataController: SoftPosDataControllerProtocol

    init(softPosDataController: SoftPosDataControllerProtocol) {
        self.softPosDataController = softPosDataController
    }

    func makeVC() -> UIViewController {
        let landingFactory = LandingTableModuleFactory(
            decorationMap: decorationMap,
            cells: cells
        )
        let landingModule = landingFactory.makeModule()
        let viewModel = SoftPosFirstStepViewModel(
            tableViewModel: landingModule.viewModel,
            builderFactory: SmartBetLandingBuilderFactory(),
            softPosDataController: softPosDataController
        )

        let vc = SoftPosFirstStepViewController(
            landingTableVC: landingModule.table
        )

        vc.diffableObserver = landingModule.observer
        vc.viewModel = viewModel

        let bottomAction = SelectorEvent(
            selector: #selector(SoftPosFirstStepViewController.didTapBottomButton),
            events: .touchUpInside
        )

        viewModel.bottomAction = bottomAction

        return vc
    }
}

private extension SoftPosFirstStepFactory {
    var decorationMap: DecorationMap {
        let map = DecorationMap()

        map.register(
            BaseSimpleTextCellTextStyleDecoration(typeStyle: .footnote3),
            for: SoftPosFirstStep.Cell.Common.id
        )

        map.register(
            DSEdgeInsetsDecoration(
                insets: .init(
                    top: .level6,
                    bottom: .level0,
                    horizontal: .level0
                )
            ),
            for: LandingBannerTableViewCell.self
        )

        map.register(
            BackgoundColorDecoration(backgroundColor: DSColors.Background.colorOnBackgroundThird.color),
            for: PrimaryButtonCell.self
        )

        map.register(
            LinesSecondaryDecoration(numberOfLines: 2),
            for: ListWithActionTableViewCell.self
        )

        map.register(
            BackgoundColorDecoration(backgroundColor: DSColors.Background.colorOnBackgroundThird.color),
            for: ListConfigurableCell.self
        )

        return map
    }

    var cells: [LandingTableCell] {
        [
            NACellInjector(
                cell: LandingPromoHeaderCell.self,
                viewModel: LandingPromoHeaderViewModel.self
            ),

            NACellInjector(
                cell: ProductLandingSectionHeaderTableViewCell.self,
                viewModel: ProductLandingSectionHeaderViewModel.self
            ),

            NACellInjector(
                cell: SectionHeaderTableViewCell.self,
                viewModel: SectionHeaderViewModel.self
            ),

            NACellInjector(
                cell: AcquiringHeaderCell.self,
                viewModel: AcquiringHeaderModel.self
            ),

            NACellInjector(
                cell: SimpleTextWithLinkCell.self,
                viewModel: SimpleTextWithLinkCellViewModel.self,
                bundle: .dsKitBundle
            ),

            NACellInjector(
                cell: LandingFeatureTableViewCell.self,
                viewModel: FeatureViewModel.self
            ),

            NACellInjector(
                cell: TerminalInfoCell.self,
                viewModel: TerminalInfoViewModel.self
            ),

            NACellInjector(
                cell: LandingBannerTableViewCell.self,
                viewModel: LandingBannerViewModel.self
            ),

            NACellInjector(
                cell: ChipsTableViewCell.self,
                viewModel: ChipsViewModel.self
            ),

            NACellInjector(
                cell: ListConfigurableCell.self,
                viewModel: ListConfigurableViewModel.self
            ),

            NACellInjector(
                cell: TextButtonCell.self,
                viewModel: TextButtonCellVM.self
            ),

            NACellInjector(
                cell: InputAndSliderViewCell.self,
                viewModel: InputAndSliderVM.self
            ),

            NACellInjector(
                cell: ProductLandingQuestionTableViewCell.self,
                viewModel: ProductLandingQuestionViewModel.self,
                bundle: .dsKitBundle
            ),

            NACellInjector(
                cell: ListWithActionTableViewCell.self,
                viewModel: ListWithActionViewModel.self
            ),

            IdentifiableCellInjector(
                cell: BaseSimpleTextCell.self,
                viewModelId: SoftPosFirstStep.Cell.Common.id,
                cellIdentifier: SoftPosFirstStep.Cell.Common.id
            ),

            NACellInjector(
                cell: StepperCell.self,
                viewModel: StepperCellContainerViewModel.self
            ),

            NACellInjector(
                cell: BaseSwitchCell.self,
                viewModel: BaseSwitchViewModel.self
            ),

            NACellInjector(
                cell: PrimaryButtonCell.self,
                viewModel: PrimaryButtonCellVM.self
            ),
        ]
    }
}
