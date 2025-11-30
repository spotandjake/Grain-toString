---
title: ToString
---

Module for converting Grain values to their string representations.

```grain
toString(true) == "true"
```

```grain
toString(123) == "123"
```

## Values

Functions and constants included in the ToString module.

### ToString.**toString**

```grain
toString: (val: a) => String
```

Converts any Grain value to its string representation.

Parameters:

| param | type | description                |
| ----- | ---- | -------------------------- |
| `val` | `a`  | The Grain value to convert |

Returns:

| type     | description                                  |
| -------- | -------------------------------------------- |
| `String` | The string representation of the Grain value |

