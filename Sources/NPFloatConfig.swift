//
//  NPFloatConfig.swift
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

public final class NPFloatConfig<T>: NPBaseConfig<T>
    where T: BinaryFloatingPoint & Comparable
{
    // MARK: - Parameters

    public let precision: Int

    public init(_ val: T,
                precision: Int = NumberPadEnum.defaultPrecision,
                upperBound: T = T.greatestFiniteMagnitude)
    {
        self.precision = precision

        let formatter = {
            let nf = NumberFormatter()
            nf.locale = Locale.current
            nf.numberStyle = .decimal
            nf.usesGroupingSeparator = false
            nf.isLenient = true
            nf.minimumFractionDigits = 0
            nf.maximumFractionDigits = precision
            nf.generatesDecimalNumbers = true
            return nf
        }()

        let sVal = Self.toString(val, upperBound: upperBound, formatter: formatter)

        super.init(sValue: sVal, upperBound: upperBound, formatter: formatter)
    }

    // MARK: - Type-specific Actions

    override public var showDecimalPoint: Bool { precision > 0 }

    override public func decimalPointAction() -> Bool {
        guard decimalPointIndex == nil else { return false }
        sValue.append(".")

        return true
    }

    // MARK: - Internal

    internal static func toString(_ val: T, upperBound: T, formatter: NumberFormatter) -> String {
        let clampedValue = max(0, min(val, upperBound))
        let doubleValue = Double(clampedValue)
        return formatter.string(from: doubleValue as NSNumber) ?? "0"
    }

    override internal func validateDigit(_: NumberPadEnum) -> Bool {
        let cp = currentPrecision
        if cp > 0, cp == precision { return false } // ignore additional input
        return true
    }

    override internal func toValue(_ str: String) -> T? {
        guard let val: NSNumber = formatter.number(from: str)
        else { return nil }
        return T(val.doubleValue)
    }

    internal var currentPrecision: Int {
        guard let di = decimalPointIndex else { return 0 }
        return sValue.distance(from: di, to: sValue.endIndex) - 1
    }

    internal var decimalPointIndex: String.Index? {
        sValue.firstIndex(of: ".")
    }
}
