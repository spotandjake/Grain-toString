---
title: Doc
---

  The Doc module implements a document IR and engine for pretty-printing code.
  Concatenation of Doc.t nodes is O(1) and printing a document is O(n) to the
  size of the document.

  The most important aspect of the engine are groups and how breaks interact
  with them. By default, the engine will print a group by either breaking none
  of the break hints in that group if the entire group would fit on that line
  (known as Flat mode) or all of the break hints in that group if the group
  would not fit if printed in Flat mode (known as Breaking mode). This covers
  95% of formatting use cases, and users should tend to reach for default
  groups before considering one of the alternatives. For the remaining 5% of
  use cases, groups can also be created in FitGroups mode or FitAll mode. In
  FitGroups mode, the engine will attempt to print as many subgroups in Flat
  mode as possible on each line, breaking only when necessary. In FitAll mode,
  the engine will attempt to print as many subgroups in Breaking mode as
  possible on each line.

  Hardlines should be avoided. Instead, emit break hints and allow the engine
  to decide when breaks should be made. If hardlines must be used, consider
  using the group's ~print_width parameter to manually specify how wide the
  engine should consider the group. By default, a group is only considered as
  wide as the content leading to the first hardline.

  That's most of what you need to know to effectively use this module! Further
  details on each node are provided below for maintainers or curious consumers.

  IR nodes:
    • Empty
      Has no effect on the output of the printing engine.
    • GroupBreaker
      Causes the enclosing group to be printed in Breaking mode.
    • Char
      Prints the char as-is. The `char` function is Utf8-aware.
    • String
      Prints the string as-is. The `string` function is Utf8-aware.
    • Blank
      Prints the specified number of spaces.
    • BreakHint
      Tells the engine that a break can be made here. If the engine decides not
      to print a break, it prints the supplied document instead.
    • Hardline
      Forces the engine to print a newline character. Width calculations for
      the current line are truncated at the Hardline. If the `phantom` field is
      set to `true`, instead the Hardline is calculated as a zero-width non-
      breaking character (the newline is emitted in the output, but
      calculations assume it's just not there).
    • IfBroken
      If the engine has broken the current group, prints the `breaking`
      document and prints the `flat` document otherwise. Note that for FitAll
      and FitGroups groups, the `flat` document would be printed if the
      IfBroken node appears before the point at which the group is broken, as
      the engine makes that decision while printing the group (unlike default
      groups, where the engine makes this decision before printing the group).
    • Indent
      Introduces indentation equal to the number of spaces specified when the
      enclosing group is broken. When newline characters are emitted, they are
      followed by space characters equal to the amount of indentation that has
      been applied by all groups, unless this would lead to trailing
      whitespace. Note that if the enclosing group has not been broken, the
      indentation will not apply. For example, in this document,
        group(~kind=FitGroups, indent(2,
          group(indent(2, string("foo") ++ break ++ string("bar")))
        ))
      if the break hint is broken by the engine, `bar`'s indentation level will
      only be two spaces, as the outer group could never be broken be broken by
      the engine.
    • Group
      ~kind=Auto
        The engine checks if the group would fit on the current line if printed
        in Flat mode. If so, it prints the group in Flat mode and Breaking mode
        otherwise.
      ~kind=FitGroups
        The engine begins printing the group. When it encounters a break hint,
        it checks if the following node would fit on the current line. If that
        node is a Group, its Flat mode width is used for the check. If the node
        would not fit, a break is emitted.
      ~kind=FitAll
        The engine begins printing the group. When it encounters a break hint,
        it checks if the following node would fit on the current line. If that
        node is a Group, its Breaking mode width is used for the check. If the
        node would not fit, a break is emitted.
    • Concat
      Prints the first document followed by the second document. Keeps track of
      the combined width to allow the engine to make constant-time decisions
      about line breaks.

## Types

Type declarations included in the Doc module.

### Doc.**EOL**

```grain
enum EOL {
  CRLF,
  LF,
}
```

### Doc.**LayoutNode**

```grain
type LayoutNode
```

### Doc.**GroupType**

```grain
enum GroupType {
  Auto,
  FitGroups,
  FitAll,
}
```

### Doc.**Width**

```grain
type Width
```

## Values

Functions and constants included in the Doc module.

### Doc.**empty**

```grain
empty: LayoutNode
```

### Doc.**groupBreaker**

```grain
groupBreaker: LayoutNode
```

### Doc.**string**

```grain
string: (s: String) => LayoutNode
```

### Doc.**blank**

```grain
blank: (c: Number) => LayoutNode
```

### Doc.**hardline**

```grain
hardline: LayoutNode
```

### Doc.**phantomHardline**

```grain
phantomHardline: LayoutNode
```

### Doc.**ifBroken**

```grain
ifBroken: (breaking: LayoutNode, flat: LayoutNode) => LayoutNode
```

### Doc.**indent**

```grain
indent: (?count: Number, doc: LayoutNode) => LayoutNode
```

### Doc.**group**

```grain
group:
  (?printWidth: Option<Number>, ?kind: GroupType, doc: LayoutNode) =>
   LayoutNode
```

### Doc.**(++)**

```grain
(++): (left: LayoutNode, right: LayoutNode) => LayoutNode
```

### Doc.**concatMap**

```grain
concatMap:
  (sep: ((a, a) => LayoutNode), lead: (a => LayoutNode),
   trail: (a => LayoutNode), f: ((final: Bool, a) => LayoutNode), l: 
   List<a>) => LayoutNode
```

### Doc.**breakableSpace**

```grain
breakableSpace: LayoutNode
```

### Doc.**_break**

```grain
_break: LayoutNode
```

### Doc.**space**

```grain
space: LayoutNode
```

### Doc.**comma**

```grain
comma: LayoutNode
```

### Doc.**commaBreakableSpace**

```grain
commaBreakableSpace: LayoutNode
```

### Doc.**parens**

```grain
parens:
  (?wrap: ((doc: LayoutNode) => LayoutNode), doc: LayoutNode) => LayoutNode
```

### Doc.**braces**

```grain
braces:
  (?wrap: ((doc: LayoutNode) => LayoutNode), doc: LayoutNode) => LayoutNode
```

### Doc.**arrayBrackets**

```grain
arrayBrackets:
  (?wrap: ((doc: LayoutNode) => LayoutNode), doc: LayoutNode) => LayoutNode
```

### Doc.**listBrackets**

```grain
listBrackets:
  (?wrap: ((doc: LayoutNode) => LayoutNode), doc: LayoutNode) => LayoutNode
```

### Doc.**angleBrackets**

```grain
angleBrackets:
  (?wrap: ((doc: LayoutNode) => LayoutNode), doc: LayoutNode) => LayoutNode
```

### Doc.**doubleQuotes**

```grain
doubleQuotes: (doc: LayoutNode) => LayoutNode
```

### Doc.**singleQuotes**

```grain
singleQuotes: (doc: LayoutNode) => LayoutNode
```

### Doc.**trailingComma**

```grain
trailingComma: LayoutNode
```

## Doc.Engine

### Values

Functions and constants included in the Doc.Engine module.

#### Doc.Engine.**print**

```grain
print:
  (write: (String => a), eol: EOL, lineWidth: Number, doc: LayoutNode) =>
   Void
```

#### Doc.Engine.**toString**

```grain
toString: (eol: EOL, lineWidth: Number, doc: LayoutNode) => String
```

