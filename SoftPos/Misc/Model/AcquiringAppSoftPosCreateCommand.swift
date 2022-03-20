//
//  AcquiringAppSoftPosCreateCommand.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 24.01.2022.
//

import Foundation

/// Заполненные клиентом данные для тарифа SoftPos
struct AcquiringAppSoftPosCreateCommand: Codable {
    /// Признак того, какой тип тарификации предлагался клиенту - в зависимости от сферы и оборота или 1% на все
    /// Значение этой переменной изначально пришло на фронт
    /// с мидл слоя в одноименном поле
    /// методов GET /acquiring/softPos/commissionMCC (на шаге 2 оферты)
    /// и GET /acquiring/softPos/commissionGroupTurnover (на ленинге)
    var isOnePercentTarification: Bool

    /// Номер документа.
    /// Этот параметр всегда будет пустым.
    /// Он остался в методе по аналогии с тарифом Аренда.
    /// Номер документа запрашивается внутри метода
    /// вызовом метода псб-онлайн getNextNumberByType(psbDocType).
    var documentNumber: String?

    /// Количество терминалов
    var terminalCount: Int

    /// Подключение услуги СБП
    var supportQps: Bool

    /// Подключение услуги быстрых зачислений
    var supportFrequentTransfer: Bool

    /// Подключение приложения Мобильная касса
    var supportMobileCashRegister: Bool

    /// Подключение возможности формирования платежной ссылки
    var supportPayLink: Bool

    /// МСС код выбранной сферы деятельности. > 0
    var mcc: Int

    /// Основание пользования помещением
    var premisesOwnershipType: UserTypePossessions

    /// Email для уведомлений
    var notificationEmail: String

    /// Счет зачисления
    var account: String

    /// Название торговой точки на русском языке
    var tradePointNameRus: String

    /// Название торговой точки латиницей
    var tradePointNameLat: String

    /// Режим работы торговой точки
    var tradePointWorkingHours: String

    /// Адрес торговой точки
    var tradePointAddress: String

    /// ФИО контактного лица
    var tradePointContactFullName: String

    /// Телефон контактного лица
    var tradePointContactPhone: String

    /// Отправлять ежедневный отчет
    var reportDaily: Bool

    /// Отправлять еженедельный отчет
    var reportWeekly: Bool

    /// Отправлять ежемесячный отчет
    var reportMonthly: Bool

    /// Email для отчетов
    var reportEmail: String?

    /// Промокод
    var promocode: String?

    /// Клиент обязан производить закупки в соответствии с законом 223-ФЗ
    var fz223Customer: Bool

    /// Номер закупки клиента в соответствии с законом 223-ФЗ
    var fz223PurchaseNumber: String?

    init(
        isOnePercentTarification: Bool = false,
        documentNumber: String? = nil,
        terminalCount: Int = 1,
        supportQps: Bool = false,
        supportFrequentTransfer: Bool = false,
        supportMobileCashRegister: Bool = false,
        supportPayLink: Bool = false,
        mcc: Int = 0,
        premisesOwnershipType: UserTypePossessions = .own,
        notificationEmail: String = "",
        account: String = "",
        tradePointNameRus: String = "",
        tradePointNameLat: String = "",
        tradePointWorkingHours: String = "",
        tradePointAddress: String = "",
        tradePointContactFullName: String = "",
        tradePointContactPhone: String = "",
        reportDaily: Bool = false,
        reportWeekly: Bool = false,
        reportMonthly: Bool = false,
        reportEmail: String? = nil,
        promocode: String? = nil,
        fz223Customer: Bool = false,
        fz223PurchaseNumber: String? = nil
    ) {
        self.isOnePercentTarification = isOnePercentTarification
        self.documentNumber = documentNumber
        self.terminalCount = terminalCount
        self.supportQps = supportQps
        self.supportFrequentTransfer = supportFrequentTransfer
        self.supportMobileCashRegister = supportMobileCashRegister
        self.supportPayLink = supportPayLink
        self.mcc = mcc
        self.premisesOwnershipType = premisesOwnershipType
        self.notificationEmail = notificationEmail
        self.account = account
        self.tradePointNameRus = tradePointNameRus
        self.tradePointNameLat = tradePointNameLat
        self.tradePointWorkingHours = tradePointWorkingHours
        self.tradePointAddress = tradePointAddress
        self.tradePointContactFullName = tradePointContactFullName
        self.tradePointContactPhone = tradePointContactPhone
        self.reportDaily = reportDaily
        self.reportWeekly = reportWeekly
        self.reportMonthly = reportMonthly
        self.reportEmail = reportEmail
        self.promocode = promocode
        self.fz223Customer = fz223Customer
        self.fz223PurchaseNumber = fz223PurchaseNumber
    }
}
