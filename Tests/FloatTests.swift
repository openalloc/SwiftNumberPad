//
//  FloatTests.swift
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

import XCTest

@testable import NumberPad

class FloatTests: XCTestCase {
    func testNoArgs() throws {
        let x = NumPadFloat(0.0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testInitZero() throws {
        let x = NumPadFloat(0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testInit1() throws {
        let x = NumPadFloat(1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)
    }

    func testInit1_0() throws {
        let x = NumPadFloat(1.0)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)
    }

    func testInit1_1() throws {
        let x = NumPadFloat(1.1)
        XCTAssertEqual("1.1", x.stringValue)
        XCTAssertEqual(1.1, x.value)
    }

    func testInitBad() throws {
        let x = NumPadFloat(-1, upperBound: 1)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testValueLargeWithinPrecision() throws {
        let x = NumPadFloat(2_348_938.93, precision: 2)
        XCTAssertEqual("2348938.93", x.stringValue)
        XCTAssertEqual(2_348_938.93, x.value)
    }

    func testValueLargeBeyondPrecisionRounds() throws {
        let x = NumPadFloat(2_348_938.936, precision: 2)
        XCTAssertEqual("2348938.94", x.stringValue)
        XCTAssertEqual(2_348_938.94, x.value)
    }

    func testBadDigits() throws {
        let x = NumPadFloat(34.3)
        let r1 = x.digitAction(.backspace)
        XCTAssertFalse(r1)
        XCTAssertEqual("34.3", x.stringValue)
        XCTAssertEqual(34.3, x.value)

        let r2 = x.digitAction(.decimalPoint)
        XCTAssertFalse(r2)
        XCTAssertEqual("34.3", x.stringValue)
        XCTAssertEqual(34.3, x.value)
    }

    func testAddAndRemoveDigits() throws {
        let x = NumPadFloat(0.0)
        let r1 = x.digitAction(.d1)
        XCTAssertTrue(r1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        let r2 = x.digitAction(.d2)
        XCTAssertTrue(r2)
        XCTAssertEqual("12", x.stringValue)
        XCTAssertEqual(12, x.value)

        x.backspaceAction()
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testRedundantZero() throws {
        let x = NumPadFloat(0.0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)

        let r = x.digitAction(.d0)
        XCTAssertTrue(r)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testAddDigitAndDecimalPoint() throws {
        let x = NumPadFloat(0.0)
        let r1 = x.digitAction(.d1)
        XCTAssertTrue(r1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        let d = x.decimalPointAction()
        XCTAssertTrue(d)
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)

        let r2 = x.digitAction(.d2)
        XCTAssertTrue(r2)
        XCTAssertEqual("1.2", x.stringValue)
        XCTAssertEqual(1.2, x.value)
    }

    func testBackspaceDecimalPoint() throws {
        let x = NumPadFloat(1.2)
        XCTAssertEqual("1.2", x.stringValue)
        XCTAssertEqual(1.2, x.value)

        x.backspaceAction()
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)

        x.backspaceAction()
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testRedundantBackspace() throws {
        let x = NumPadFloat(1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testRedundantAdjacentDecimalPoint() throws {
        let x = NumPadFloat(0.0)
        let r = x.digitAction(.d1)
        XCTAssertTrue(r)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        let d1 = x.decimalPointAction()
        XCTAssertTrue(d1)
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)

        let d2 = x.decimalPointAction()
        XCTAssertFalse(d2)
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)
    }

    func testRedundantSecondDecimalPoint() throws {
        let x = NumPadFloat(1.2)

        XCTAssertEqual("1.2", x.stringValue)
        XCTAssertEqual(1.2, x.value)

        let d = x.decimalPointAction()
        XCTAssertFalse(d)
        XCTAssertEqual("1.2", x.stringValue)
        XCTAssertEqual(1.2, x.value)
    }

    func testDecimalPointBackspace() throws {
        let x = NumPadFloat(0.0)
        let r = x.digitAction(.d1)
        XCTAssertTrue(r)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        let d1 = x.decimalPointAction()
        XCTAssertTrue(d1)
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)

        let d2 = x.decimalPointAction()
        XCTAssertFalse(d2)
        XCTAssertEqual("1.", x.stringValue)
        XCTAssertEqual(1, x.value)
    }

    func testPenny() throws {
        let x = NumPadFloat(0.0, precision: 2)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
        XCTAssertEqual(0, x.currentPrecision)

        let d = x.decimalPointAction()
        XCTAssertTrue(d)
        XCTAssertEqual("0.", x.stringValue)
        XCTAssertEqual(0, x.value)
        XCTAssertEqual(0, x.currentPrecision)

        let r1 = x.digitAction(.d0)
        XCTAssertTrue(r1)
        XCTAssertEqual("0.0", x.stringValue)
        XCTAssertEqual(0, x.value)
        XCTAssertEqual(1, x.currentPrecision)

        let r2 = x.digitAction(.d1)
        XCTAssertTrue(r2)
        XCTAssertEqual("0.01", x.stringValue)
        XCTAssertEqual(0.01, x.value)
        XCTAssertEqual(2, x.currentPrecision)
    }

    func testIgnoreIfBeyondPrecision() throws {
        let x = NumPadFloat(0.01, precision: 2)

        XCTAssertEqual("0.01", x.stringValue)
        XCTAssertEqual(0.01, x.value)
        XCTAssertEqual(2, x.currentPrecision)

        let r = x.digitAction(.d9)
        XCTAssertFalse(r)
        XCTAssertEqual("0.01", x.stringValue)
        XCTAssertEqual(0.01, x.value)
        XCTAssertEqual(2, x.currentPrecision)
    }

    func testInitializeOutsidePrecision() throws {
        let x = NumPadFloat(10.18, precision: 1)
        XCTAssertEqual("10.2", x.stringValue)
        XCTAssertEqual(10.2, x.value)
    }

    func testInitializeInsideRange() throws {
        let x = NumPadFloat(10, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }

    func testInitializeOutsideRange() throws {
        let x = NumPadFloat(10.01, precision: 2, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }

    func testIgnoreIfOutsideRange() throws {
        let x = NumPadFloat(10, precision: 2, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)

        let d = x.decimalPointAction()
        XCTAssertTrue(d)
        XCTAssertEqual("10.", x.stringValue)
        XCTAssertEqual(10, x.value)
        XCTAssertEqual(0, x.currentPrecision)

        let r1 = x.digitAction(.d0)
        XCTAssertTrue(r1)
        XCTAssertEqual("10.0", x.stringValue)
        XCTAssertEqual(10, x.value)
        XCTAssertEqual(1, x.currentPrecision)

        let r2 = x.digitAction(.d1)
        XCTAssertFalse(r2)
        XCTAssertEqual("10.0", x.stringValue)
        XCTAssertEqual(10.0, x.value)
        XCTAssertEqual(1, x.currentPrecision)

        let r3 = x.digitAction(.d0)
        XCTAssertTrue(r3)
        XCTAssertEqual("10.00", x.stringValue)
        XCTAssertEqual(10, x.value)
        XCTAssertEqual(2, x.currentPrecision)
    }
}
