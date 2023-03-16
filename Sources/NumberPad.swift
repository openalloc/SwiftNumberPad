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

public struct NumberPad<T>: View
    where T: Comparable
{
    @ObservedObject private var config: NPBaseConfig<T>
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let onEntry: (NumberPadEnum, Bool) -> Void

    // MARK: - Parameters

    public init(config: NPBaseConfig<T>,
                horizontalSpacing: CGFloat = NumberPadEnum.defaultHorizontalSpacing,
                verticalSpacing: CGFloat = NumberPadEnum.defaultVerticalSpacing,
                onEntry: @escaping (NumberPadEnum, Bool) -> Void = { _, _ in })
    {
        self.config = config
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.onEntry = onEntry
    }

    // MARK: - Views

    public var body: some View {
        VStack(spacing: verticalSpacing) {
            HStack(spacing: horizontalSpacing) {
                digit(.d1)
                digit(.d2)
                digit(.d3)
            }
            HStack(spacing: horizontalSpacing) {
                digit(.d4)
                digit(.d5)
                digit(.d6)
            }
            HStack(spacing: horizontalSpacing) {
                digit(.d7)
                digit(.d8)
                digit(.d9)
            }
            HStack(spacing: horizontalSpacing) {
                if config.showDecimalPoint {
                    decimalPoint
                } else {
                    blank
                }
                digit(.d0)
                backspace
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var blank: some View {
        Text("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func digit(_ digit: NumberPadEnum) -> some View {
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
        .disabled(config.isClear)
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

    private func digitAction(_ digit: NumberPadEnum) {
        let result = config.digitAction(digit)
        onEntry(digit, result)
    }

    private func clearAction() {
        config.clearAction()
        onEntry(.clear, true)
    }

    private func decimalPointAction() {
        let result = config.decimalPointAction()
        onEntry(.decimalPoint, result)
    }

    private func backspaceAction() {
        config.backspaceAction()
        onEntry(.backspace, true)
    }
}

struct NumberPad_Previews: PreviewProvider {
    struct TestHolder: View {
        @ObservedObject var floatConfig: NPFloatConfig = .init(Float(30.0), precision: 1, upperBound: Float(700))
        @ObservedObject var integerConfig: NPIntegerConfig = .init(2333, upperBound: 30000)
        var body: some View {
            VStack {
                Text("\(floatConfig.stringValue)")

                NumberPad(config: floatConfig)
                    .buttonStyle(.bordered)
                    .font(.title2)

                #if !os(watchOS) // not enough room
                    Divider()

                    Text("\(integerConfig.stringValue)")
                    NumberPad(config: integerConfig)
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
