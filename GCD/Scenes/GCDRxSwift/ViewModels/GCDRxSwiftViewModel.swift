//
//  GCDRxSwiftViewModel.swift
//  GCD
//
//  Created by Анатолий Фетелеу on 10.04.2023.
//

import Foundation
import RxRelay


class GCDRxSwiftViewModel {
    var requestStatuses: BehaviorRelay<[Int?]> = .init(value: [])
}
