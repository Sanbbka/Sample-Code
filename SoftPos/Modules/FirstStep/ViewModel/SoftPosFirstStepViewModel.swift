//
//  SoftPosFirstStepViewModel.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//
//

import SOLIDArch
import PSBCore
import DSKit

/// VM для первого шага оферты тарифа SoftPos
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosFirstStepViewModelTests)
/// - Tag: DigitalSales.SoftPosFirstStepViewModel
final class SoftPosFirstStepViewModel: SoftPosFirstStepViewModelProtocol {

    var bottomAction: SelectorEvent?
    var navigationViewModel: SubtitlableViewModelProtocol {
        TitleAndSubtitleVM(
            title: SoftPosTexts.Offer.First.Navigation.title,
            subtitle: SoftPosTexts.Offer.First.Navigation.subtitle
        )
    }
    let softPosDataController: SoftPosDataControllerProtocol
    let tableViewModel: LandingTableViewModelProtocol
    let builderFactory: SmartBetLandingBuildingFactoryProtocol

    private var qpsMinPercent: String {
        softPosDataController.softPosData.limits.min.stringUserFriendlyValue
    }

    private var qpsMaxPercent: String {
        softPosDataController.softPosData.limits.max.stringUserFriendlyValue
    }

    private lazy var qpsSwitch = switchVM(
        title: SoftPosTexts.Offer.First.Section.Services.Qps.title,
        subtitle: SoftPosTexts.Offer.First.Section.Services.Qps.subtitle(qpsMinPercent, qpsMaxPercent),
        isOn: softPosDataController.softPosViewModel.supportQps,
        toolTipText: SoftPosTexts.Offer.First.Section.Services.Qps.toolTip(qpsMinPercent, qpsMaxPercent),
        identifier: SoftPosFirstStep.Cell.Service1.id
    )

    private lazy var sftSwitch = makeStfSwitch()

    private lazy var cashRegisterSwitch = switchVM(
        title: SoftPosTexts.Offer.First.Section.Services.CashRegister.title,
        subtitle: SoftPosTexts.Offer.First.Section.Services.CashRegister.subtitle,
        isOn: softPosDataController.softPosViewModel.supportMobileCashRegister,
        toolTipText: SoftPosTexts.Offer.First.Section.Services.CashRegister.toolTip,
        identifier: SoftPosFirstStep.Cell.Service3.id
    )

    private lazy var payLinkSwitch = switchVM(
        title: SoftPosTexts.Offer.First.Section.Services.PayLink.title,
        subtitle: SoftPosTexts.Offer.First.Section.Services.PayLink.subtitle,
        isOn: softPosDataController.softPosViewModel.supportPayLink,
        toolTipText: SoftPosTexts.Offer.First.Section.Services.PayLink.toolTip,
        identifier: SoftPosFirstStep.Cell.Service4.id
    )

    init(
        tableViewModel: LandingTableViewModelProtocol,
        builderFactory: SmartBetLandingBuildingFactoryProtocol,
        softPosDataController: SoftPosDataControllerProtocol
    ) {
        self.tableViewModel = tableViewModel
        self.builderFactory = builderFactory
        self.softPosDataController = softPosDataController
    }

    func reloadData() {
        softPosDataController.supportQpsToggle(isOn: qpsSwitch.switchVM.isOn)
        softPosDataController.supportFrequentTransferToggle(isOn: sftSwitch.switchVM.isOn)
        softPosDataController.supportCashRegisterToggle(isOn: cashRegisterSwitch.switchVM.isOn)
        softPosDataController.supportPayLinkToggle(isOn: payLinkSwitch.switchVM.isOn)

        buildSections()
    }

    func updateTerminal(count: Int) {
        softPosDataController.terminalCount = count
        buildSections()
    }
}

private extension SoftPosFirstStepViewModel {
    var header: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosFirstStep.Section.Header.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Offer.First.Section.Header.title)
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Offer.First.Section.Header.text,
                    identifier: SoftPosFirstStep.Cell.Common.id
                )
            )

        return builder.section
    }

    var terminalSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosFirstStep.Section.Terminals.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Offer.First.Section.Terminal.title)
            .addCommon(
                viewModel: StepperCellContainerViewModel(
                    left: .none,
                    middle: StepperViewModel(value: softPosDataController.terminalCount),
                    right: .none
                )
            )

        return builder.section
    }

    var servicesSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosFirstStep.Section.Services.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Offer.First.Section.Services.title)
            .addCommon(viewModel: qpsSwitch)
            .addCommon(viewModel: sftSwitch)
            .addCommon(viewModel: cashRegisterSwitch)
            .addCommon(viewModel: payLinkSwitch)

        return builder.section
    }

    var footer: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosFirstStep.Section.Footer.id)

        let rows = softPosDataController.landingFooterViewModel.makeFooterVM()
        rows.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }

    var bottomButton: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosFirstStep.Section.BottomButton.id)

        let actions = [bottomAction].compactMap { $0 }
        builder.addCommon(
            viewModel: PrimaryButtonCellVM(
                title: Localize.continueButtonText,
                actions: actions
            )
        )

        return builder.section
    }
}

private extension SoftPosFirstStepViewModel {
    func buildSections() {
        let sections = [
            header,
            terminalSection,
            servicesSection,
            footer,
            bottomButton
        ]
        tableViewModel.update(sections: sections)
    }

    func switchVM(
        title: String,
        subtitle: String?,
        isOn: Bool,
        toolTipText: String?,
        identifier: String) -> BaseSwitchViewModel {
        var toolTipType: SwitchViewToolTipType?
        if let toolTipText = toolTipText {
            let toolTipVM = ToolTipViewModel(toolTipText: toolTipText)
            toolTipType = .toolTip(toolTipVM)
        }

        return BaseSwitchViewModel(
            textType: .titleAndSubtitle(TitleAndSubtitleVM(title: title, subtitle: subtitle)),
            toolTipType: toolTipType,
            switchVM: SwitchViewModel(isOn: isOn),
            identifier: identifier
        )
    }

    func makeStfSwitch() -> BaseSwitchViewModel {
        switchVM(
            title: SoftPosTexts.Offer.First.Section.Services.Stf.title,
            subtitle: SoftPosTexts.Offer.First.Section.Services.Stf.subtitle(softPosDataController.frequentTransferCost ?? ""),
            isOn: softPosDataController.softPosViewModel.supportFrequentTransfer,
            toolTipText: SoftPosTexts.Offer.First.Section.Services.Stf.toolTip(softPosDataController.frequentTransferCost ?? ""),
            identifier: SoftPosFirstStep.Cell.Service2.id
        )
    }
}
