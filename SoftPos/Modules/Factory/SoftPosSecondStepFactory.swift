//
//  SoftPosSecondStepFactory.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 08.02.2022.
//

import SOLIDArch
import DSKit
import UIKit
import SMBCore
import PSBCore
import Confirmation
import Signing

/// Фабрика для второго шага `SoftPos`
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosSecondStepFactoryTests)
/// - Tag: DigitalSales.SoftPosSecondStepFactory
struct SoftPosSecondStepFactory {

    let softPosDataController: SoftPosDataControllerProtocol

    init(softPosDataController: SoftPosDataControllerProtocol) {
        self.softPosDataController = softPosDataController
    }

    func makeVC() -> UIViewController {
        let dependency = DependencyContainer.shared
        let landingFactory = LandingTableModuleFactory(
            decorationMap: decorationMap,
            cells: cells
        )
        let landingModule = landingFactory.makeModule()
        let viewModel = SoftPosSecondStepViewModel(
            tableViewModel: landingModule.viewModel,
            builderFactory: SmartBetLandingBuilderFactory(),
            softPosDataController: softPosDataController,
            documentProvider: DocumentSigningProvider(),
            provider: AcquiringProvider(config: .default),
            permission: dependency.permissionProvider?.permission,
            cyrillicCompanyNameValidator: CyrillicCompanyNameValidator()
        )

        let actionMap = NAActionMapDifferenceCompliable()

        actionMap.register(#selector(SoftPosSecondStepViewController.didTapFieldOfActivity),
                           for: SoftPosSecondStep.Cell.FieldOfActivity.id)
        actionMap.register(#selector(SoftPosSecondStepViewController.didTapSelectAccount),
                           for: TitleWithRightDetailViewCellVM.self)

        let vc = SoftPosSecondStepViewController(
            landingTableVC: landingModule.table
        )

        vc.diffableObserver = landingModule.observer
        vc.viewModel = viewModel
        vc.confirmationRouter = PSBConfirmationConfiguratorRouter(vc: vc)
        landingModule.table.actionProcessor?.actionMap = actionMap

        let bottomAction = SelectorEvent(
            selector: #selector(SoftPosSecondStepViewController.didTapBottomButton),
            events: .touchUpInside
        )

        viewModel.bottomAction = bottomAction

        return vc
    }
}

private extension SoftPosSecondStepFactory {
    var decorationMap: DecorationMap {
        let map = DecorationMap()

        map.register(
            BaseSimpleTextCellTextStyleDecoration(typeStyle: .footnote3),
            for: SoftPosSecondStep.Cell.Common.id
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
                viewModelId: SoftPosSecondStep.Cell.Common.id,
                cellIdentifier: SoftPosSecondStep.Cell.Common.id
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

            NACellInjector(
                cell: TextFieldCell.self,
                viewModel: TextFieldCellVM.self
            ),

            NACellInjector(
                cell: MultilineFieldTableCell.self,
                viewModel: MultilineFieldVM.self
            ),

            NACellInjector(
                cell: BaseCheckboxCell.self,
                viewModel: BaseCheckboxViewModel.self
            ),

            NACellInjector(
                cell: TitleWithRightDetailViewCell.self,
                viewModel: TitleWithRightDetailViewCellVM.self
            ),
        ]
    }
}
