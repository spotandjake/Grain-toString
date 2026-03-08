---
title: GrainValue
---

Unsafe utilities for extracting runtime tag information from grain values.

Note:
  This module is unsafe and should be used with caution.
  The grain team offers no guarantees on breaking changes or
  end user support.

## Types

Type declarations included in the GrainValue module.

### GrainValue.**VariantType**

```grain
enum VariantType<a> {
  EmptyVariant,
  TupleVariant(Array<WasmRef>),
  RecordVariant(Array<(String, WasmRef)>),
}
```

Represents the variant's field data types.

Note: The `a` is `forall a`, meaning we never want to unify it.

Variants:

```grain
EmptyVariant
```

A variant with no attached data.

```grain
TupleVariant(Array<WasmRef>)
```

A variant with tuple data attached.

```grain
RecordVariant(Array<(String, WasmRef)>)
```

A variant with record data attached.

## Values

Functions and constants included in the GrainValue module.

### GrainValue.**isSimpleNumberValue**

```grain
isSimpleNumberValue: (val: a) => Bool
```

Checks if the given grain value is a simple number.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                     |
| ------ | --------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a simple number, `false` otherwise |

### GrainValue.**isHeapValue**

```grain
isHeapValue: (val: a) => Bool
```

Checks if the given grain value is a heap value.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                  |
| ------ | ------------------------------------------------------------ |
| `Bool` | `true` if the grain value is a heap value, `false` otherwise |

### GrainValue.**isConstantValue**

```grain
isConstantValue: (val: a) => Bool
```

Checks if the given grain value is a constant value.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                      |
| ------ | ---------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a constant value, `false` otherwise |

### GrainValue.**isShortValue**

```grain
isShortValue: (val: a) => Bool
```

Checks if the given grain value is a short value.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                   |
| ------ | ------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a short value, `false` otherwise |

### GrainValue.**isChar**

```grain
isChar: (ref: WasmRef) => Bool
```

Checks if the given grain value is a char short value.

Parameters:

| param | type      | description              |
| ----- | --------- | ------------------------ |
| `ref` | `WasmRef` | The grain value to check |

Returns:

| type   | description                                                        |
| ------ | ------------------------------------------------------------------ |
| `Bool` | `true` if the grain value is a char short value, `false` otherwise |

### GrainValue.**isInt8**

```grain
isInt8: (ref: WasmRef) => Bool
```

Checks if the given grain value is a int8 short value.

Parameters:

| param | type      | description              |
| ----- | --------- | ------------------------ |
| `ref` | `WasmRef` | The grain value to check |

Returns:

| type   | description                                                        |
| ------ | ------------------------------------------------------------------ |
| `Bool` | `true` if the grain value is a int8 short value, `false` otherwise |

### GrainValue.**isInt16**

```grain
isInt16: (ref: WasmRef) => Bool
```

Checks if the given grain value is a int16 short value.

Parameters:

| param | type      | description              |
| ----- | --------- | ------------------------ |
| `ref` | `WasmRef` | The grain value to check |

Returns:

| type   | description                                                         |
| ------ | ------------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a int16 short value, `false` otherwise |

### GrainValue.**isUInt8**

```grain
isUInt8: (ref: WasmRef) => Bool
```

Checks if the given grain value is a uint8 short value.

Parameters:

| param | type      | description              |
| ----- | --------- | ------------------------ |
| `ref` | `WasmRef` | The grain value to check |

Returns:

| type   | description                                                         |
| ------ | ------------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a uint8 short value, `false` otherwise |

### GrainValue.**isUInt16**

```grain
isUInt16: (ref: WasmRef) => Bool
```

Checks if the given grain value is a uint16 short value.

Parameters:

| param | type      | description              |
| ----- | --------- | ------------------------ |
| `ref` | `WasmRef` | The grain value to check |

Returns:

| type   | description                                                          |
| ------ | -------------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a uint16 short value, `false` otherwise |

### GrainValue.**getTupleData**

```grain
getTupleData: (ref: WasmRef) => Array<WasmRef>
```

Provides the tuples tagged contents.

Parameters:

| param | type      | description                                         |
| ----- | --------- | --------------------------------------------------- |
| `ref` | `WasmRef` | A reference to the tuple value to extract data from |

Returns:

| type             | description                                          |
| ---------------- | ---------------------------------------------------- |
| `Array<WasmRef>` | An array of values representing the tuple's elements |

### GrainValue.**getRecordData**

```grain
getRecordData: (record_: WasmRef) => Array<(String, WasmRef)>
```

Provides the record's tagged field data.

Parameters:

| param     | type      | description                                  |
| --------- | --------- | -------------------------------------------- |
| `record_` | `WasmRef` | The tagged record value to extract data from |

Returns:

| type                       | description                                                              |
| -------------------------- | ------------------------------------------------------------------------ |
| `Array<(String, WasmRef)>` | An associated array of field names and their corresponding tagged values |

### GrainValue.**getVariantData**

```grain
getVariantData: (ref: WasmRef) => (String, VariantType<a>)
```

Provides the variant's tagged field data.

Parameters:

| param | type      | description                                           |
| ----- | --------- | ----------------------------------------------------- |
| `ref` | `WasmRef` | A reference to the variant value to extract data from |

Returns:

| type                       | description                            |
| -------------------------- | -------------------------------------- |
| `(String, VariantType<a>)` | The name and field data of the variant |

### GrainValue.**isListVariant**

```grain
isListVariant: (ref: WasmRef) => Bool
```

Checks if the given ADT value is a List variant.

Parameters:

| param | type      | description             |
| ----- | --------- | ----------------------- |
| `ref` | `WasmRef` | The ADT value to check. |

Returns:

| type   | description                                                   |
| ------ | ------------------------------------------------------------- |
| `Bool` | `true` if the ADT value is a List variant, `false` otherwise. |

