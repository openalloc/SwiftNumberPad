//
//  NumberPadEnum.swift
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

public enum NumberPadEnum: Int {
    case d0 = 0
    case d1 = 1
    case d2 = 2
    case d3 = 3
    case d4 = 4
    case d5 = 5
    case d6 = 6
    case d7 = 7
    case d8 = 8
    case d9 = 9
    case backspace = 10
    case decimalPoint = 11
    case clear = 12

    var isDigit: Bool {
        (0 ... 9).contains(rawValue)
    }

    var toString: String {
        "\(rawValue)"
    }

    public static let defaultPrecision: Int = 2

    #if os(watchOS)
        public static let defaultHorizontalSpacing: CGFloat = 3
        public static let defaultVerticalSpacing: CGFloat = 3
    #else
        public static let defaultHorizontalSpacing: CGFloat = 10
        public static let defaultVerticalSpacing: CGFloat = 10
    #endif
}
