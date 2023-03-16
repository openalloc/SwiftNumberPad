//
//  NumberPadExample.swift
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

#if DEBUG
    struct NumberPadExample: View {
        @Binding var calories: Float

        init(myValue: Binding<Float>) {
            _calories = myValue
            config = .init(myValue.wrappedValue, precision: 1, upperBound: 1000)
        }

        @ObservedObject var config: NPFloatConfig<Float>

        var body: some View {
            VStack {
                Text("\(config.stringValue)")

                NumberPad(config: config)
                    .buttonStyle(.bordered)
            }
            .font(.largeTitle)
            .navigationTitle("Calories")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        calories = config.value ?? 0
                    }
                }
            }
            .padding()
        }
    }

    struct NumPadExample_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                NumberPadExample(myValue: .constant(Float(233.6)))
            }
        }
    }
#endif
