# SwiftNumberPad

A multi-platform SwiftUI component for basic number input.

Available as an open source library to be incorporated in SwiftUI apps.

_SwiftNumberPad_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## Features

* Support for both integer and floating point types
* Presently targeting .macOS(.v13), .iOS(.v16), .watchOS(.v9)
* No external dependencies!

## Example

A basic example of Float-based input with a specified precision.

```swift
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

            NumberPad(config: config, showDecimalPoint: true)
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
```

<img src="https://github.com/openalloc/SwiftNumberPad/blob/main/Images/float_demo.png" width="178" height="350">

## TODO

Please submit pull requests if you'd like to tackle any of these. Thanks!

* Usage documentation in this README
* SwiftUI Preview not reliably working on macOS
* See if earlier versions of platforms can be supported
* Support for negative values
* Support for Decimal input

## See Also

* [SwiftSideways](https://github.com/openalloc/SwiftSideways) - multi-platform SwiftUI component for the horizontal scrolling of tabular data in compact areas
* [SwiftDetailer](https://github.com/openalloc/SwiftDetailer) - multi-platform SwiftUI component for editing fielded data
* [SwiftDetailerMenu](https://github.com/openalloc/SwiftDetailerMenu) - optional menu support for _SwiftDetailer_
* [SwiftCompactor](https://github.com/openalloc/SwiftCompactor) - formatters for the concise display of Numbers, Currency, and Time Intervals
* [SwiftModifiedDietz](https://github.com/openalloc/SwiftModifiedDietz) - A tool for calculating portfolio performance using the Modified Dietz method
* [SwiftNiceScale](https://github.com/openalloc/SwiftNiceScale) - generate 'nice' numbers for label ticks over a range, such as for y-axis on a chart
* [SwiftRegressor](https://github.com/openalloc/SwiftRegressor) - a linear regression tool that’s flexible and easy to use
* [SwiftSeriesResampler](https://github.com/openalloc/SwiftSeriesResampler) - transform a series of coordinate values into a new series with uniform intervals
* [SwiftSimpleTree](https://github.com/openalloc/SwiftSimpleTree) - a nested data structure that’s flexible and easy to use

And open source apps using this library (by the same author):

* [Gym Routine Tracker](https://open-trackers.github.io/grt/) - minimalist workout tracker, for the Apple Watch, iPhone, and iPad
* [Daily Calorie Tracker](https://open-trackers.github.io/dct/) - minimalist calorie tracker, for the Apple Watch, iPhone, and iPad

* [FlowAllocator](https://openalloc.github.io/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://openalloc.github.io/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS

## License

Copyright 2023 OpenAlloc LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.
