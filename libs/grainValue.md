---
title: GrainValue
---

Unsafe utilities for extracting runtime tag information from grain values.

Note:
  This module is unsafe and should be used with caution.
  The grain team offers no guarantees on breaking changes or
  end user support.

## Values

Functions and constants included in the GrainValue module.

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

### GrainValue.**isStackValue**

```grain
isStackValue: (val: a) => Bool
```

Checks if the given grain value is a stack value.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                   |
| ------ | ------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a stack value, `false` otherwise |

### GrainValue.**isSimpleNumberValue**

```grain
isSimpleNumberValue: (val: a) => Bool
```

Checks if the given grain value is a simple number.

NOTE:
This throws a wasm trap if the value is a not a (ref i31),
isStackValue should be used to check for (ref i31) values
before calling this function.

Parameters:

| param | type | description              |
| ----- | ---- | ------------------------ |
| `val` | `a`  | The grain value to check |

Returns:

| type   | description                                                     |
| ------ | --------------------------------------------------------------- |
| `Bool` | `true` if the grain value is a simple number, `false` otherwise |

### GrainValue.**isConstantValue**

```grain
isConstantValue: (val: a) => Bool
```

Checks if the given grain value is a constant value.

NOTE:
This throws a wasm trap if the value is a not a (ref i31),
isStackValue should be used to check for (ref i31) values
before calling this function.

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

NOTE:
This throws a wasm trap if the value is a not a (ref i31),
isStackValue should be used to check for (ref i31) values
before calling this function.

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

Provides the tuples contents.

Parameters:

| param | type      | description                                         |
| ----- | --------- | --------------------------------------------------- |
| `ref` | `WasmRef` | A reference to the tuple value to extract data from |

Returns:

| type             | description                                              |
| ---------------- | -------------------------------------------------------- |
| `Array<WasmRef>` | An array of references representing the tuple's elements |

### GrainValue.**getRecordData**

```grain
getRecordData: (ref: WasmRef) => Array<(String, WasmRef)>
```

Provides the records field data along with field names if available.

If the names are not available, the field names will be returned as "<unknown field>".

Parameters:

| param | type      | description                                                  |
| ----- | --------- | ------------------------------------------------------------ |
| `ref` | `WasmRef` | The reference to the record value to extract field data from |

Returns:

| type                       | description                                                       |
| -------------------------- | ----------------------------------------------------------------- |
| `Array<(String, WasmRef)>` | An associated array of field names and their corresponding values |

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

## GrainValue.TypeMetaData

Provides utilities for accessing type metadata.

### Values

Functions and constants included in the GrainValue.TypeMetaData module.

#### GrainValue.TypeMetaData.**getRecordMetaData**

```grain
getRecordMetaData: (ref: WasmRef) => Array<String>
```

Provides the metadata for a record type.

Parameters:

| param | type      | description                                                |
| ----- | --------- | ---------------------------------------------------------- |
| `ref` | `WasmRef` | The reference to the record value to extract metadata from |

Returns:

| type            | description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| `Array<String>` | The names of the fields in the record, or an empty array if none found |

#### GrainValue.TypeMetaData.**getVariantMetaData**

```grain
getVariantMetaData: (ref: WasmRef) => (String, Array<String>)
```

Provides the metadata for a variant type.

Parameters:

| param | type      | description                                                 |
| ----- | --------- | ----------------------------------------------------------- |
| `ref` | `WasmRef` | The reference to the variant value to extract metadata from |

Returns:

| type                      | description                        |
| ------------------------- | ---------------------------------- |
| `(String, Array<String>)` | The name and fields of the variant |

