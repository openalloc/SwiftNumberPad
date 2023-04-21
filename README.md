# SwiftNumberPad

A multi-platform SwiftUI component for basic number input.

Available as an open source library to be incorporated in SwiftUI apps.

_SwiftNumberPad_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

<img src="https://github.com/openalloc/SwiftNumberPad/blob/main/Images/float_demo.png" width="178" height="350">

## Features

* Support for integer, floating point, and Decimal types
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
```


## TODO

Please submit pull requests if you'd like to tackle any of these. Thanks!

* Usage documentation in this README
* SwiftUI Preview not reliably working on macOS
* See if earlier versions of platforms can be supported
* Support for negative values

## See Also

This library is a member of the _OpenAlloc Project_.

* [_OpenAlloc_](https://openalloc.github.io) - product website for all the _OpenAlloc_ apps and libraries
* [_OpenAlloc Project_](https://github.com/openalloc) - Github site for the development project, including full source code

## License

Copyright 2023 OpenAlloc LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.
