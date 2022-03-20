//
//  SoftPosSecondStepViewModel+Section.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 08.02.2022.
//
//

import Foundation
import SOLIDArch
import DSKit

extension SoftPosSecondStepViewModel {
    var sections: [NASection] {
        [
            headerSection,
            outletSection,
            contactSection,
            reportSection,
            bonusesSection,
            footerSection,
            bottomSection
        ]
    }
}

// MARK: - Private Sections
private extension SoftPosSecondStepViewModel {
    var headerSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Header.id)

        let fieldOfActivity = result.fieldOfActivity.text
        if let mcc = smartCommissionMCC.first(where: { $0.name == fieldOfActivity }) {
            var bottomText = softPosDataController.isOnePercentTarification ?
                SoftPosTexts.Landing.OnePercent.Section.title
                : mcc.commissionDesctiption

            if softPosDataController.softPosViewModel.supportQps {
                bottomText += ", по СБП \(mcc.qpcCommissionText)%"
            }

            result.fieldOfActivity.bottomText = bottomText
        } else {
            result.fieldOfActivity.bottomText = nil
        }

        let fields = [
            result.fieldOfActivity,
            result.email
        ]

        builder.addWhiteSectionHeader(text: SoftPosTexts.Offer.Second.Section.company)
        fields.forEach { builder.addCommon(viewModel: $0) }
        builder
            .addCommon(viewModel: result.placeOfTerminal)
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Offer.Second.Section.Header.account,
                    identifier: SoftPosSecondStep.Cell.Common.id
                )
            )

        if let account = softPosDataController.selectedAccount {
            let type = AccountType(rawValue: account.type) ?? .accountTypeUnknown
            let text = type.translate()
            let rightText = account.formattedAmountWithoutNullKopeek
            let vm = TitleWithRightDetailViewCellVM(
                titleText: text,
                rightDetailText: rightText,
                isChevronHidden: accounts.count <= 1
            )

            builder.addCommon(viewModel: vm)
        }

        return builder.section
    }

    var outletSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Store.id)

        builder.addWhiteSectionHeader(text: SoftPosTexts.Offer.Second.Section.outlet)

        let fields: [NAItemViewModel] = [
            result.companyName,
            result.multilineCompanyNameEn,
            result.openHours,
            result.address
        ]

        fields.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }

    var contactSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Contact.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Offer.Second.Section.contact)
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Offer.Second.Section.Contact.text,
                    identifier: SoftPosSecondStep.Cell.Common.id
                )
            )

        let fields = [
            result.fullName,
            result.phoneNumber,
        ]

        fields.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }

    var reportSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Reporting.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Offer.Second.Section.reporting)
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: Localize.secondStepOfferReportDetail,
                    identifier: SoftPosSecondStep.Cell.Common.id
                )
            )

        var fields = [
            result.dailyReportCheckbox,
            result.weeklyReportCheckbox,
            result.monthlyReportCheckbox,
        ] as [NAItemViewModel]

        if result.dailyReportCheckbox.isSelected ||
            result.weeklyReportCheckbox.isSelected ||
            result.monthlyReportCheckbox.isSelected {
            fields.append(result.reporingEmail)
        }

        fields.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }

    var bonusesSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Bonuses.id)

        builder.addWhiteSectionHeader(text: SoftPosTexts.Offer.Second.Section.bonuses)

        var fields = [
            result.promocode,
            result.fz223Customer
        ] as [NAItemViewModel]

        if result.fz223Customer.isSelected {
            fields.append(result.purchaseNumber)
        }

        fields.forEach { builder.addCommon(viewModel: $0) }

        if !result.fz223Customer.isSelected {
            builder.addSimpleTextWithWhiteBackground("")
        }

        return builder.section
    }

    var footerSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Section.Footer.id)

        let rows = softPosDataController.landingFooterViewModel.makeFooterVM()
        rows.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }

    var bottomSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosSecondStep.Cell.BottomButton.id)
        let actions = [bottomAction].compactMap { $0 }
        let buttonVM = PrimaryButtonCellVM(title: bottomButtonText, actions: actions)
        builder.addCommon(viewModel: buttonVM)

        return builder.section
    }

    var bottomButtonText: String {
        let canSign = hasSignAndExecutePermission

        return canSign ? SoftPosTexts.Offer.Second.Button.sign
            : SoftPosTexts.Offer.Second.Button.save
    }
}
