//
//  NPBaseConfig.swift
//
// Copyright 2023 OpenAlloc LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

open class NPBaseConfig<T>: ObservableObject
    where T: Comparable
{
    @Published public var sValue: String
    public let upperBound: T
    internal let formatter: NumberFormatter

    public init(sValue: String, upperBound: T, formatter: NumberFormatter) {
        self.sValue = sValue
        self.upperBound = upperBound
        self.formatter = formatter
    }

    // MARK: - Public Properties

    public var showDecimalPoint: Bool { false }

    public var stringValue: String {
        sValue
    }

    public var value: T? {
        toValue(sValue)
    }

    public var isClear: Bool {
        sValue == "0"
    }

    // MARK: - Actions

    public func clearAction() {
        sValue = "0"
    }

    public func backspaceAction() {
        if sValue.count <= 1 {
            clearAction()
        } else {
            sValue.removeLast()
        }
    }

    public func digitAction(_ digit: NumberPadEnum) -> Bool {
        guard digit.isDigit else { return false }
        let strNum = digit.toString
        if isClear {
            sValue = strNum
        } else {
            guard validateDigit(digit) else { return false }

            let nuValue = sValue.appending(strNum)

            guard let nuDValue = toValue(nuValue),
                  nuDValue <= upperBound else { return false }

            sValue = nuValue
        }

        return true
    }

    public func decimalPointAction() -> Bool { false }

    // MARK: - Internal methods to override

    internal func toValue(_: String) -> T? { nil }
    internal func validateDigit(_: NumberPadEnum) -> Bool { true }
}
