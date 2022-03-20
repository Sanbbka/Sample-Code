//
//  SoftPosLandingFactory.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 30.11.2021.
//

import Foundation
import SOLIDArch
import DSKit
import UIKit
import SMBCore
import PSBCore

/// Фабрика для лэндинга `SoftPos`
/// - Tag: DigitalSales.SoftPosLandingFactory
struct SoftPosLandingFactory {

    init() {}

    func makeVC(softPosData: SoftPosData) -> UIViewController {
        let landingFactory = LandingTableModuleFactory(
            decorationMap: decorationMap,
            cells: cells
        )
        let dependency = DependencyContainer.shared
        let accountStore = dependency.accountsDataStore
        let accounts = accountStore?.availableUserAccounts ?? []
        let softPosDataController = SoftPosDataController(
            softPosData: softPosData,
            accounts: accounts,
            userEmail: dependency.clientProvider?.client.email)
        let landingModule = landingFactory.makeModule()
        let viewModel = SoftPosViewModel(
            tableViewModel: landingModule.viewModel,
            builderFactory: SmartBetLandingBuilderFactory(),
            softPosDataController: softPosDataController
        )

        let vc = SoftPosLandingViewController(
            landingTableVC: landingModule.table,
            diffableObserver: landingModule.observer
        )
        vc.viewModel = viewModel

        return vc
    }
}

private extension SoftPosLandingFactory {
    var decorationMap: DecorationMap {
        let map = DecorationMap()

        map.register(
            BaseSimpleTextCellTextStyleDecoration(typeStyle: .body1),
            for: SoftPosLanding.Cell.Common.id
        )

        map.register(
            BaseSimpleTextCellTextStyleDecoration(typeStyle: .body1),
            for: SoftPosLanding.Cell.Title.id
        )

        map.register(
            DSEdgeInsetsDecoration(insets: DSEdgeInsets(top: .level5, bottom: .level0)),
            for: SoftPosLanding.Cell.Title.id
        )

        map.register(
            BaseSimpleTextCellColorDecoration(color: DSColors.Text.colorTextPrimary.color),
            for: SoftPosLanding.Cell.Title.id
        )

        map.register(
            BaseSimpleTextCellTextStyleDecoration(typeStyle: .subheadline1_3),
            for: SoftPosLanding.Cell.Subtitle.id
        )

        map.register(
            BaseSimpleTextCellColorDecoration(color: DSColors.Text.colorTextSecondary.color),
            for: SoftPosLanding.Cell.Subtitle.id
        )

        map.register(DSEdgeInsetsDecoration(insets: .init(vertical: .level6, horizontal: .level0)), for: ChipsTableViewCell.self)

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
            LinesSecondaryDecoration(numberOfLines: 2),
            for: ListWithActionTableViewCell.self
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
                cell: ListConfigurableCell.self,
                viewModel: ListConfigurableViewModel.self
            ),

            IdentifiableCellInjector(
                cell: BaseSimpleTextCell.self,
                viewModelId: SoftPosLanding.Cell.Title.id,
                cellIdentifier: SoftPosLanding.Cell.Title.id
            ),

            IdentifiableCellInjector(
                cell: BaseSimpleTextCell.self,
                viewModelId: SoftPosLanding.Cell.Subtitle.id,
                cellIdentifier: SoftPosLanding.Cell.Subtitle.id
            ),

            IdentifiableCellInjector(
                cell: BaseSimpleTextCell.self,
                viewModelId: SoftPosLanding.Cell.Common.id,
                cellIdentifier: SoftPosLanding.Cell.Common.id
            ),
        ]
    }
}
