//
//  SoftPosLandingFooterViewModel.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 25.01.2022.
//

import DSKit

/// Вьюмодель для футтера тарифа SoftPos
struct SoftPosLandingFooterViewModel {
    struct Item {
        let name: String
        var value: String?

        var footerViewModel: ListConfigurableViewModel? {
            guard let value = value else {
                return nil
            }

            return ListConfigurableViewModel(
                title: name,
                rightDetail: value,
                titleColor: .secondary,
                rightDetailColor: .primary,
                titleTextSize: .small,
                rightDetailTextSize: .small,
                identifier: SoftPosLanding.Cell.Footer.id + name
            )
        }
    }

    var tarif = Item(
        name: SoftPosTexts.Offer.First.Section.Footer.Tarif.name,
        value: SoftPosTexts.Offer.First.Section.Footer.Tarif.value
    )
    var phones = Item(name: SoftPosTexts.Offer.First.Section.Footer.Phones.name)
    var fieldOfActivity = Item(name: SoftPosTexts.Offer.First.Section.Footer.FieldOfActivity.name)
    var comission = Item(name: SoftPosTexts.Offer.First.Section.Footer.Comission.name)
    var qps = Item(name: SoftPosTexts.Offer.First.Section.Footer.Qps.name)
    var fastPayments = Item(name: SoftPosTexts.Offer.First.Section.Footer.Sfp.name)
    var cashRegister = Item(
        name: SoftPosTexts.Offer.First.Section.Footer.CashRegister.name,
        value: SoftPosTexts.Offer.First.Section.Footer.CashTarif.value
    )
    var payLink = Item(
        name: SoftPosTexts.Offer.First.Section.Footer.PayLink.name,
        value: SoftPosTexts.Offer.First.Section.Footer.CashTarif.value
    )

    func makeFooterVM() -> [ListConfigurableViewModel] {
        [
            ListConfigurableViewModel(title: nil, rightDetail: nil)
        ]
        +
        [
            tarif,
            phones,
            fieldOfActivity,
            comission,
            qps,
            fastPayments,
            cashRegister,
            payLink
        ].compactMap { $0.footerViewModel }
    }
}
