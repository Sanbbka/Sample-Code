//
//  SoftPosFirstStepViewModelProtocol.swift
//  DigitalSales
//
//  Created by Alexander Drovnyashin on 21.01.2022.
//
//

import Foundation
import DSKit
import SOLIDArch

/// Протокол VM для первого шага оферты тарифа SoftPos
protocol SoftPosFirstStepViewModelProtocol: AnyObject {
    var navigationViewModel: SubtitlableViewModelProtocol { get }
    var softPosDataController: SoftPosDataControllerProtocol { get }

    func reloadData()
    func updateTerminal(count: Int)
}
