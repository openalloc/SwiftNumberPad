//
//  IntegerTests.swift
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

class IntegerTests: XCTestCase {
    func testNoArgs() throws {
        let x = NPIntegerConfig(0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testInitZero() throws {
        let x = NPIntegerConfig(0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testInit1() throws {
        let x = NPIntegerConfig(1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)
    }

    func testInit10() throws {
        let x = NPIntegerConfig(10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }

    func testInitBad() throws {
        let x = NPIntegerConfig(-1, upperBound: 1)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testValueLarge() throws {
        let x = NPIntegerConfig(2_348_938)
        XCTAssertEqual("2348938", x.stringValue)
        XCTAssertEqual(2_348_938, x.value)
    }

    func testBadDigits() throws {
        let x = NPIntegerConfig(34)
        let r1 = x.digitAction(.backspace)
        XCTAssertFalse(r1)
        XCTAssertEqual("34", x.stringValue)
        XCTAssertEqual(34, x.value)

        let r2 = x.digitAction(.decimalPoint)
        XCTAssertFalse(r2)
        XCTAssertEqual("34", x.stringValue)
        XCTAssertEqual(34, x.value)
    }

    func testAddAndRemoveDigits() throws {
        let x = NPIntegerConfig(0)
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
        let x = NPIntegerConfig(0)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)

        let r = x.digitAction(.d0)
        XCTAssertTrue(r)
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testRedundantBackspace() throws {
        let x = NPIntegerConfig(1)
        XCTAssertEqual("1", x.stringValue)
        XCTAssertEqual(1, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)

        x.backspaceAction()
        XCTAssertEqual("0", x.stringValue)
        XCTAssertEqual(0, x.value)
    }

    func testInitializeInsideRange() throws {
        let x = NPIntegerConfig(10, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }

    func testInitializeOutsideRange() throws {
        let x = NPIntegerConfig(11, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }

    func testIgnoreIfOutsideRange() throws {
        let x = NPIntegerConfig(10, upperBound: 10)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)

        let r1 = x.digitAction(.d0)
        XCTAssertFalse(r1)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)

        let r2 = x.digitAction(.d1)
        XCTAssertFalse(r2)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)

        let r3 = x.digitAction(.d0)
        XCTAssertFalse(r3)
        XCTAssertEqual("10", x.stringValue)
        XCTAssertEqual(10, x.value)
    }
}
