//
//  SoftPosViewModel.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 29.11.2021.
//
//

import Foundation
import SOLIDArch
import DSKit
import PSBCore

/// `ViewModel` лэндинга для тарифа `SoftPos`
///
/// [Тесты](x-source-tag://DigitalSales.SoftPosViewModelTests)
/// - Tag: DigitalSales.SoftPosViewModel
final class SoftPosViewModel: SoftPosViewModelProtocol {

    let softPosDataController: SoftPosDataControllerProtocol

    private let tableViewModel: LandingTableViewModelProtocol
    private let builderFactory: SmartBetLandingBuildingFactoryProtocol

    private var textFieldVM = TextFieldModel(
        isEnabled: false,
        isUserInteractionEnabled: false,
        isError: false,
        isErrorSetByValidator: false,
        keyboardType: .numberPad,
        formatter: .limiter(CharsetCountLimiter(.count(count: 12))),
        validator: InnValidator()
    )

    private lazy var questions =
        [
            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.pay,
                answer: SoftPosTexts.Landing.Answer.pay,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.docs,
                answer: SoftPosTexts.Landing.Answer.docs,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.start,
                answer: SoftPosTexts.Landing.Answer.start,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.device,
                answer: SoftPosTexts.Landing.Answer.device,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.download,
                answer: SoftPosTexts.Landing.Answer.download,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.limits,
                answer: SoftPosTexts.Landing.Answer.limits,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.comissions,
                answer: SoftPosTexts.Landing.Answer.comissions,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.card,
                answer: SoftPosTexts.Landing.Answer.card,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.services,
                answer: SoftPosTexts.Landing.Answer.services,
                isFolded: true
            ),

            ProductLandingQuestionViewModel(
                question: SoftPosTexts.Landing.Question.questions,
                answer: SoftPosTexts.Landing.Answer.questions,
                isFolded: true
            ),
        ]

    private let chipsViewModel: ChipsViewModel
    private var sliderIndex: Int {
        var sliderIndex = 0
        if let index = currentActivity?
            .commission
            .firstIndex(where: { $0.min <= currentSliderValue && currentSliderValue < $0.max }) {
            sliderIndex = index
        }

        let commissions = currentActivity?.commission

        if let minValue = commissions?.first?.maxTurnoverRub,
           minValue == currentSliderValue {
            sliderIndex = 0
        } else if let maxValue = commissions?.last?.minTurnoverRub,
                  maxValue == currentSliderValue,
                  let comissionsCount = currentActivity?.commission.count {
            sliderIndex = comissionsCount - 1
        }

        return sliderIndex
    }

    private var selectedChipsIndex: Int {
        chipsViewModel.selectedIndexes.first ?? 0
    }
    private var currentActivity: SmartMCCGroupsDataModel? {
        softPosDataController.softPosData.commissionGroupTurnover.mccGroups?[safe: selectedChipsIndex]
    }
    private var currentSliderValue = 200_000

    init(
        tableViewModel: LandingTableViewModelProtocol,
        builderFactory: SmartBetLandingBuildingFactoryProtocol,
        softPosDataController: SoftPosDataControllerProtocol
    ) {
        self.tableViewModel = tableViewModel
        self.builderFactory = builderFactory
        self.softPosDataController = softPosDataController

        let chipsItems = softPosDataController
            .softPosData
            .commissionGroupTurnover
            .mccGroups?
            .compactMap { ChipsTagViewModel(title: $0.groupName) } ?? []

        self.chipsViewModel = ChipsViewModel(
            selectionEnabled: true,
            multipleSelection: false,
            items: chipsItems,
            layoutMode: .linear,
            selectedIndexes: [0]
        )
    }

    func buildSections() {
        let sections = [
            header,
            featureSection,
            calculatorSection,
            paymentsTypeDescriptionSection,
            moreFeatureSection,
            comissionBanner,
            faqSection
        ]
        tableViewModel.update(sections: sections)
    }

    func sliderCellDidChangeValue(value: Int) -> Int {
        let step = 2000
        let newValue = value / step * step

        currentSliderValue = newValue

        return newValue
    }
}

private extension SoftPosViewModel {
    var header: NASection {
        var tariffPercent = softPosDataController.tariffPercent
        if !softPosDataController.isOnePercentTarification {
            tariffPercent = "от " + tariffPercent
        }

        let detailText = SoftPosTexts.Landing.Header.detail(tariffPercent)

        let headerModel = LandingPromoHeaderViewModel(
            titleText: SoftPosTexts.Landing.Header.title,
            detailText: detailText,
            descriptionText: SoftPosTexts.Landing.Header.description,
            icon: SalesImages.phone,
            identifier: SoftPosLanding.Section.Header.id
        )

        return NASection(with: [
            headerModel
        ])
    }

    var featureSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.Feature.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Landing.Feature.Section.title)
            .addFeature(
                title: SoftPosTexts.Landing.Feature.Step._1.title,
                body: SoftPosTexts.Landing.Feature.Step._1.body,
                icon: DSIcons.Promo.smartphone
            )
            .addFeature(
                title: SoftPosTexts.Landing.Feature.Step._2.title,
                body: SoftPosTexts.Landing.Feature.Step._2.body,
                icon: DSIcons.Promo.cardwireless
            )
            .addFeature(
                title: SoftPosTexts.Landing.Feature.Step._3.title,
                body: SoftPosTexts.Landing.Feature.Step._3.body,
                icon: DSIcons.Promo.handshake
            )
            .addFeature(
                title: SoftPosTexts.Landing.Feature.Step._4.title,
                body: SoftPosTexts.Landing.Feature.Step._4.body,
                icon: DSIcons.Promo.docOk
            )

        return builder.section
    }

    var calculatorSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.Calculator.id)

        guard !softPosDataController.isOnePercentTarification else {
            builder.addWhiteSectionHeader(text: SoftPosTexts.Landing.OnePercent.Section.title)
            builder.addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.OnePercent.Section.subtitle,
                    identifier: SoftPosLanding.Cell.Common.id
                )
            )

            return builder.section
        }

        builder.addWhiteSectionHeader(text: SoftPosTexts.Landing.Calculator.Section.title)
        builder.addCommon(
            viewModel: BaseSimpleTextCellVM(
                title: SoftPosTexts.Landing.Calculator.Section.subtitle,
                identifier: SoftPosLanding.Cell.Common.id
            )
        )

        builder.addChipsControl(vm: chipsViewModel)

        builder.addCommon(
            viewModel: BaseSimpleTextCellVM(
                title: SoftPosTexts.Landing.Calculator.Section.Terminal.text,
                identifier: SoftPosLanding.Cell.Common.id
            )
        )

        let commissions = currentActivity?.commission

        var minValue = commissions?.first?.maxTurnoverRub ?? 0
        var maxValue = commissions?.last?.minTurnoverRub ?? 0

        let step = 2_000
        maxValue = maxValue.roundedValue(places: step)
        minValue = minValue.roundedValue(places: step)

        let leftText = Localize.smartBetTariffLeftText(Int(minValue / 1000))
        let rightText = Localize.smartBetTariffRightText(Int(maxValue / 1000))

        if minValue > currentSliderValue || maxValue < currentSliderValue {
            let offset = Double(maxValue - minValue) * 0.2

            currentSliderValue = minValue + Int(offset)
        }

        let topText: String
        if currentSliderValue == minValue {
            topText = SoftPosTexts.Landing.Calculator.Top.Min.text
        } else if currentSliderValue == maxValue {
            topText = SoftPosTexts.Landing.Calculator.Top.Max.text
        } else {
            topText = ""
        }

        let sliderVM = InputAndSliderVM(
            topText: topText,
            currency: "₽",
            value: NSDecimalNumber(value: currentSliderValue),
            minimumValue: Float(minValue),
            maximumValue: Float(maxValue),
            leftLabelText: leftText,
            rightLabelText: rightText,
            isEnale: true,
            textFieldModel: textFieldVM
        )

        sliderVM.value = NSDecimalNumber(value: currentSliderValue)

        builder.addInputAndSlider(viewModel: sliderVM)

        let currentCommission = currentActivity?.commission[safe: sliderIndex]
        let commissionPercent = currentCommission?.commissionPercent ?? 0
        let minCommission = currentActivity?.minCommissionPercent.stringUserFriendlyValue ?? ""

        let listVM = ListConfigurableViewModel(
            title: "\(commissionPercent.stringUserFriendlyValue)%",
            rightDetail: SoftPosTexts.Landing.Calculator.Section.texts(minCommission + "%"),
            titleColor: .primary,
            rightDetailColor: .secondary,
            titleTextSize: .large,
            rightDetailTextSize: .small
        )
        builder.addCommon(viewModel: listVM)

        return builder.section
    }

    var paymentsTypeDescriptionSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.PaymentsTypeDescription.id)
        let qpsPercent = softPosDataController.softPosData.limits.min.stringUserFriendlyValue

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Landing.Payments.Section.title)
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.Pay.device,
                    identifier: SoftPosLanding.Cell.Title.id
                )
            )
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.Pay.card,
                    identifier: SoftPosLanding.Cell.Subtitle.id
                )
            )
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.Pay.qr,
                    identifier: SoftPosLanding.Cell.Title.id
                )
            )
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.comission(qpsPercent),
                    identifier: SoftPosLanding.Cell.Subtitle.id
                )
            )
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.link,
                    identifier: SoftPosLanding.Cell.Title.id
                )
            )
            .addCommon(
                viewModel: BaseSimpleTextCellVM(
                    title: SoftPosTexts.Landing.Payments.service,
                    identifier: SoftPosLanding.Cell.Subtitle.id
                )
            )

        return builder.section
    }

    var moreFeatureSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.MoreFeatureSection.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Landing.More.Feature.Section.title)
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Online.title,
                body: SoftPosTexts.Landing.More.Feature.Online.body,
                icon: DSIcons.Promo.comp
            )
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Fast.title,
                body: SoftPosTexts.Landing.More.Feature.Fast.body,
                icon: DSIcons.Promo.rocket
            )
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Safety.title,
                body: SoftPosTexts.Landing.More.Feature.Safety.body,
                icon: DSIcons.Promo.zp
            )
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Support.title,
                body: SoftPosTexts.Landing.More.Feature.Support.body,
                icon: DSIcons.Promo.support
            )
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Law.title,
                body: SoftPosTexts.Landing.More.Feature.Law.body,
                icon: DSIcons.Promo.doc
            )
            .addFeature(
                title: SoftPosTexts.Landing.More.Feature.Analytics.title,
                body: SoftPosTexts.Landing.More.Feature.Analytics.body,
                icon: DSIcons.Promo.chart
            )

        return builder.section
    }

    var comissionBanner: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.ComissionBanner.id)
        builder.addGrayBanner(
            title: SoftPosTexts.Landing.More.Feature.Comission.title,
            body: SoftPosTexts.Landing.More.Feature.Comission.body
        )

        return builder.section
    }

    var faqSection: NASection {
        let builder = builderFactory.makeBuilder(identifier: SoftPosLanding.Section.Faq.id)

        builder
            .addWhiteSectionHeader(text: SoftPosTexts.Landing.Question.Section.title)

        questions.forEach { builder.addCommon(viewModel: $0) }

        return builder.section
    }
}
