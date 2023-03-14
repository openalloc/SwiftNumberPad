//
//  NumberPad.swift
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

import SwiftUI

public struct NumberPad<T>: View {
    @ObservedObject private var selection: NumPadBase<T>
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let showDecimalPoint: Bool
    private let onEntry: (NumPad, Bool) -> Void

    // MARK: - Parameters

    public init(selection: NumPadBase<T>,
                horizontalSpacing: CGFloat = NumPad.defaultHorizontalSpacing,
                verticalSpacing: CGFloat = NumPad.defaultVerticalSpacing,
                showDecimalPoint: Bool,
                onEntry: @escaping (NumPad, Bool) -> Void = { _, _ in })
    {
        self.selection = selection
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.showDecimalPoint = showDecimalPoint
        self.onEntry = onEntry
    }

    // MARK: - Views

    public var body: some View {
        VStack(spacing: verticalSpacing) {
            HStack(spacing: horizontalSpacing) {
                digit(NumPad.d1)
                digit(NumPad.d2)
                digit(NumPad.d3)
            }
            HStack(spacing: horizontalSpacing) {
                digit(NumPad.d4)
                digit(NumPad.d5)
                digit(NumPad.d6)
            }
            HStack(spacing: horizontalSpacing) {
                digit(NumPad.d7)
                digit(NumPad.d8)
                digit(NumPad.d9)
            }
            HStack(spacing: horizontalSpacing) {
                if showDecimalPoint {
                    decimalPoint
                } else {
                    blank
                }
                digit(NumPad.d0)
                backspace
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var blank: some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func digit(_ digit: NumPad) -> some View {
        Button(action: { digitAction(digit) }) {
            Text(digit.toString)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var backspace: some View {
        Button(action: {}) {
            Image(systemName: "delete.backward.fill")
                .imageScale(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .disabled(selection.isClear)
        .simultaneousGesture(
            LongPressGesture()
                .onEnded { _ in
                    clearAction()
                }
        )
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    backspaceAction()
                }
        )
    }

    private var decimalPoint: some View {
        Button(action: decimalPointAction) {
            Text(".")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Actions

    private func digitAction(_ digit: NumPad) {
        let result = selection.digitAction(digit)
        onEntry(digit, result)
    }

    private func clearAction() {
        selection.clearAction()
        onEntry(.clear, true)
    }

    private func decimalPointAction() {
        let result = selection.decimalPointAction()
        onEntry(.decimalPoint, result)
    }

    private func backspaceAction() {
        selection.backspaceAction()
        onEntry(.backspace, true)
    }
}

struct NumberPad_Previews: PreviewProvider {
    struct TestHolder: View {
        @ObservedObject var dValue: NumPadFloat = .init(2333.23, precision: 2, upperBound: 30000.0)
        @ObservedObject var iValue: NumPadInt = .init(2333, upperBound: 30000)
        var body: some View {
            VStack {
                Text("\(dValue.stringValue)")

                NumberPad(
                    selection: dValue,
                    showDecimalPoint: true
                )
                .buttonStyle(.bordered)
                .font(.title2)

                #if !os(watchOS) // not enough room
                    Divider()

                    Text("\(iValue.stringValue)")
                    NumberPad(
                        selection: iValue,
                        showDecimalPoint: false
                    )
                    .buttonStyle(.bordered)
                    .font(.title2)
                #endif
            }
        }
    }

    static var previews: some View {
        TestHolder()
            .accentColor(.orange)
            .symbolRenderingMode(.hierarchical)
    }
}
