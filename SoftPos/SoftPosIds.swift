//
//  SoftPosIds.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//
//

import Foundation

/// Идентификаторы для экрана лэндинга тарифа SoftPos
enum SoftPosLanding {
    enum Section {
        enum Header: ItemIdentifiable {}
        enum Feature: ItemIdentifiable {}
        enum Calculator: ItemIdentifiable {}
        enum PaymentsTypeDescription: ItemIdentifiable {}
        enum MoreFeatureSection: ItemIdentifiable {}
        enum ComissionBanner: ItemIdentifiable {}
        enum Faq: ItemIdentifiable {}
    }

    enum Cell {
        enum Title: ItemIdentifiable {}
        enum Subtitle: ItemIdentifiable {}
        enum Common: ItemIdentifiable {}
        enum Footer: ItemIdentifiable {}
    }
}

/// Идентификаторы для экрана первого шага офферты
enum SoftPosFirstStep {
    enum Section {
        enum Header: ItemIdentifiable {}
        enum Terminals: ItemIdentifiable {}
        enum Services: ItemIdentifiable {}
        enum Footer: ItemIdentifiable {}
        enum BottomButton: ItemIdentifiable {}
    }

    enum Cell {
        enum Common: ItemIdentifiable {}
        enum Service1: ItemIdentifiable {}
        enum Service2: ItemIdentifiable {}
        enum Service3: ItemIdentifiable {}
        enum Service4: ItemIdentifiable {}
    }
}

/// Идентификаторы для экрана второго шага офферты
enum SoftPosSecondStep {
    enum Section {
        enum Header: ItemIdentifiable {}
        enum Store: ItemIdentifiable {}
        enum Contact: ItemIdentifiable {}
        enum Reporting: ItemIdentifiable {}
        enum Bonuses: ItemIdentifiable {}
        enum Footer: ItemIdentifiable {}
    }

    enum Cell {
        enum Common: ItemIdentifiable {}
        enum BottomButton: ItemIdentifiable {}
        enum FieldOfActivity: ItemIdentifiable {}
        enum LatinFieldName: ItemIdentifiable {}
    }
}

/// Идентификаторы для экрана Тарифов
enum TariffsList {
    enum Section: ItemIdentifiable {}
    enum SmartBet: ItemIdentifiable {}
    enum SoftPos: ItemIdentifiable {}
}
