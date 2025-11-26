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

### GrainValue.**HeapValue**

```grain
type HeapValue<a>
```

Represents a generic grain heap value.

### GrainValue.**ShortValue**

```grain
type ShortValue<a>
```

Represents a generic grain short value.

### GrainValue.**UnknownValue**

```grain
type UnknownValue<a>
```

Represents an unknown value.

### GrainValue.**ConstantValue**

```grain
type ConstantValue<a>
```

Represents a generic grain constant value.

### GrainValue.**TupleValue**

```grain
type TupleValue<a>
```

Represents a generic grain tuple value.

### GrainValue.**RecordValue**

```grain
type RecordValue<a>
```

Represents a generic grain record value.

### GrainValue.**ADTValue**

```grain
type ADTValue<a>
```

Represents a generic grain ADT value.

### GrainValue.**LambdaValue**

```grain
type LambdaValue<a>
```

Represents a generic grain lambda value.

### GrainValue.**NumberTag**

```grain
enum NumberTag {
  SimpleNumberTag(Number),
  Int64Tag(Int64),
  Float64Tag(Float64),
  RationalTag(Rational),
  BigIntTag(BigInt),
  UnknownNumberTag,
}
```

Represents a tagged grain number value.

### GrainValue.**StackTag**

```grain
enum StackTag<a> {
  NumberTag(Number),
  HeapTag(HeapValue<a>),
  ShortTag(ShortValue<a>),
  ReservedTag(UnknownValue<a>),
  ConstantTag(ConstantValue<a>),
}
```

Represents a tagged grain stack value.

Note: The `a` is `forall a`, meaning we never want to unify it.

Variants:

```grain
NumberTag(Number)
```

simple number - 0bxx1

```grain
HeapTag(HeapValue<a>)
```

heap value - 0b00x

```grain
ShortTag(ShortValue<a>)
```

short value - 0b01x

```grain
ReservedTag(UnknownValue<a>)
```

reserved tag - 0b10x

```grain
ConstantTag(ConstantValue<a>)
```

constant tag - 0b11x

### GrainValue.**HeapTag**

```grain
enum HeapTag<a> {
  TupleTag(TupleValue<a>),
  ArrayTag(Array<a>),
  RecordTag(RecordValue<a>),
  ADTTag(ADTValue<a>),
  ClosureTag(LambdaValue<a>),
  StringTag(String),
  BytesTag(Bytes),
  BoxedNumberTag(Number),
  Int32Tag(Int32),
  Float32Tag(Float32),
  Uint32Tag(Uint32),
  Uint64Tag(Uint64),
  UnknownTag,
}
```

Represents a tagged grain heap value.

Note: The `a` is `forall a`, meaning we never want to unify it.

### GrainValue.**ShortTag**

```grain
enum ShortTag {
  CharTag(Char),
  Int8Tag(Int8),
  Int16Tag(Int16),
  Uint8Tag(Uint8),
  Uint16Tag(Uint16),
  UnknownShortTag,
}
```

Represents a tagged grain short value.

Note: The `a` is `forall a`, meaning we never want to unify it.

Variants:

```grain
CharTag(Char)
```

Char - 0b00000

```grain
Int8Tag(Int8)
```

Int8 - 0b00001

```grain
Int16Tag(Int16)
```

Int16 - 0b00010

```grain
Uint8Tag(Uint8)
```

Uint8 - 0b00011

```grain
Uint16Tag(Uint16)
```

Uint16 - 0b00100

```grain
UnknownShortTag
```

Unknown short tag

### GrainValue.**VariantType**

```grain
enum VariantType<a> {
  EmptyVariant,
  TupleVariant(List<StackTag<a>>),
  RecordVariant(List<(String, StackTag<a>)>),
}
```

## Values

Functions and constants included in the GrainValue module.

### GrainValue.**isSimpleNumberValue**

```grain
isSimpleNumberValue: (a: a) => Bool
```

### GrainValue.**isHeapValue**

```grain
isHeapValue: (a: a) => Bool
```

### GrainValue.**getTag**

```grain
getTag: (value: a) => StackTag<b>
```

Provides a tagged stack value based on the grain value type.

Parameters:

| param   | type | description             |
| ------- | ---- | ----------------------- |
| `value` | `a`  | The grain value to tag. |

Returns:

| type          | description                                                                                                                                      |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `StackTag<b>` | A tagged grain value that can be used to extract the value information.<br/><br/>Note: The `a` is `forall a`, meaning we never want to unify it. |

### GrainValue.**getHeapTag**

```grain
getHeapTag: (value: HeapValue<a>) => HeapTag<b>
```

Provides a tagged heap value based on the grain value type.

Parameters:

| param   | type           | description                  |
| ------- | -------------- | ---------------------------- |
| `value` | `HeapValue<a>` | The grain heap value to tag. |

Returns:

| type         | description                                                                                                                                           |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `HeapTag<b>` | A tagged grain heap value that can be used to extract the value information.<br/><br/>Note: The `a` is `forall a`, meaning we never want to unify it. |

### GrainValue.**getNumberTag**

```grain
getNumberTag: (value: Number) => NumberTag
```

Provides a tagged number value based on the grain value type.

Parameters:

| param   | type     | description                    |
| ------- | -------- | ------------------------------ |
| `value` | `Number` | The grain number value to tag. |

Returns:

| type        | description                                                                    |
| ----------- | ------------------------------------------------------------------------------ |
| `NumberTag` | A tagged grain number value that can be used to extract the value information. |

### GrainValue.**getShortTag**

```grain
getShortTag: (value: ShortValue<a>) => ShortTag
```

Provides a tagged short value based on the grain value type.

Parameters:

| param   | type            | description                   |
| ------- | --------------- | ----------------------------- |
| `value` | `ShortValue<a>` | The grain short value to tag. |

Returns:

| type       | description                                                                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ShortTag` | A tagged grain short value that can be used to extract the value information.<br/><br/>Note: The `a` is `forall a`, meaning we never want to unify it. |

### GrainValue.**getTupleData**

```grain
getTupleData: (value: TupleValue<a>) => List<StackTag<b>>
```

Provides the tuples tagged contents.

Parameters:

| param   | type            | description                                        |
| ------- | --------------- | -------------------------------------------------- |
| `value` | `TupleValue<a>` | The tagged grain tuple value to extract data from. |

Returns:

| type                | description                                              |
| ------------------- | -------------------------------------------------------- |
| `List<StackTag<b>>` | A list of tagged values representing the tuple's fields. |

### GrainValue.**getRecordData**

```grain
getRecordData: (value: RecordValue<a>) => Option<List<(String, StackTag<b>)>>
```

### GrainValue.**isListADT**

```grain
isListADT: (value: ADTValue<a>) => Bool
```

### GrainValue.**getADTData**

```grain
getADTData: (value: ADTValue<a>) => (Option<String>, VariantType<b>)
```

