# enum_to_string

[![CI](https://github.com/rknell/flutterEnumsToString/actions/workflows/ci.yml/badge.svg)](https://github.com/rknell/flutterEnumsToString/actions)

Better conversion of ENUMs to string - It also can handle converting back again!


## What it does

It takes an enum such as:

`enum TestEnum { testValue1 }`

and converts it to

`testValue1`

**Also handles camel case**

Input `enum TestEnum { testValue1 }`
Output `Test value 1`

You can also capitalize all words using the `capitalizeWords` flag:
Input `enum TestEnum { testValue1 }`
Output with `capitalizeWords: true`: `Test Value 1`

## Usage

```dart
import 'package:enum_to_string/enum_to_string.dart';

enum TestEnum { testValue1, testValue2 };

convert(){
    String result = EnumToString.convertToString(TestEnum.testValue1);
    //result = 'testValue1'

    String result = EnumToString.convertToString(TestEnum.testValue1, camelCase: true);
    //result = 'Test value 1'

    String result = EnumToString.convertToString(TestEnum.testValue1, camelCase: true, capitalizeWords: true);
    //result = 'Test Value 1'

    EnumToString.fromString(TestEnum.values, "testValue1"); //Enum
    // TestEnum.testValue1

    EnumToString.fromString(TestEnum.values, "Test Value 1", camelCase: true);
    // TestEnum.testValue1

    List<String> result = EnumToString.toList(TestEnum.values);
    //result = ['testValue1','testValue2'],

    List<String> result = EnumToString.toList(TestEnum.values, camelCase: true);
    //result = ['Test value 1','Test value 2'],
    
    List result = EnumToString.fromList(TestEnum.values, ["ValueOne", "Value2"]); //List<Enum>
    //result = [TestEnum.valueOne, TestEnum.value2];
}
```

## Contributing

Any pull requests / extensions welcome, this was just an annoying thing I needed to fix a couple of times so viola! a package was born.

The project uses GitHub Actions for CI (migrated from Travis CI), which automatically runs the following checks on all pull requests:
- Dart formatting
- Static analysis
- Tests

You can run all checks locally before submitting a PR using the provided script:

```bash
./tool/check.sh
```

Or run them individually:

```bash
# Get dependencies
dart pub get

# Format code
dart format --output=none --set-exit-if-changed .

# Run static analysis
dart analyze

# Run tests
dart test
```

The CI pipeline requires all tests to pass. Please ensure your changes include appropriate test coverage.
