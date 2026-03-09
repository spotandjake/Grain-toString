# Grain String

This library is an experimental rewrite of grain's internal `toString` function, it is being designed as a standalone library with the future goal of being merged into the runtime. 

This library has been developed and is maintained for `0.8.x`.

## Why
One of grain's staple features is it's amazing `print` and `toString` function, that enables amazing developer experience. However the current `print` implementation starts to become messy when working with large dataStructures such as big lists, nested dataStructures and any other larger collection of data. This is mostly because of verboseness in the output large lists get printed on a single line which makes it hard to distinguish between 

## Design

I tried to design this library in a high level and user friendly way despite the low level needs of printing in grain, as such `toString` is mostly the formatting rules and layouts itself, while the layout rules are left to `libs/doc.gr` and the low level type reflection rules are left to `grainValue.gr`

### `libs/doc.gr`

This library comes from the grain compiler and is used internally for formatting grain code, which makes it a perfect candidate for formatting our printing settings with the same semantics. It is a highly fast pretty printing and document layout formatting engine that works in `o(n)` time. This is the key to the new printing semantics as it allows us to efficiently handle inserting line breaks and breaking logic in `o(n)` time, this also allows us to use similar pretty printing logic to what grain uses internally in the compiler allowing our printing formats to be consistent with our program formatting. Some changes have been made to optimize for both size and performance compared to the version in the compiler such as using a workQueue instead of recursion in printing.

### `libs/grainValue.gr`

This library is a minimal helper library which abstracts away a lot of the tag checking operations and type metadata operations, the idea would be to merge this into `runtime/unsafe/dataStructures.gr`. Keeping these functions separate to the printing logic itself helps us keep the printing logic clean and formatting focused allowing us to work at a higher level of abstraction without sacrificing, size and performance too much. It would still be beneficial if we had [runtime tag matching](https://github.com/grain-lang/grain/issues/2208) as that would reduce the maintenance burden and provide some size and performance benefits as well.

## Size

As the goal of this project is to eventually upstream the work into the grain standard library and replace the currently language `toString` implementation it is important that we keep bundle size low and performance high, hence the optimization efforts and use of mini libraries such as `MiniBuffer`. Currently this library increases a tiny program by approximately `8kb` or `1.4x`. Speed is a little harder to compare, in the general case the overhead isn't noticeable, as can be seen by `perf.gr` even in debug mode we can print a million items in around `9s` with most of the time being spent actually printing the document tree rather than the formatting logic, in release mode this goes down to around `2s` which is pretty good considering the amount of work being done and the fact that this is a stress test, most programs won't be printing millions of items at a time, and instead will be printing smaller data structures where the overhead is negligible.

Additionally all optimization efforts have tried to avoid making `./libs/doc.gr` specific to printing as it could be used for pretty printing other built-in libraries such as `json`, `yaml` and `markdown` as well as be exposed to users directly for clean printing.

## Modular

One major difference between this library and the current `toString` implementation is that individual printers for each dataStructure is now it's own concept which allows us to provide faster more specialized printers for certain dataStructures such exposing a `Number.toString`, `String.toString` and `List.toString`, further to this we could have the compiler monomorphize calls to `toString` and `print` by replacing the calls with the specific printers. 

## Still To Be Done
+ Tests
  + Test more complex nesting scenarios
+ Discuss implementing this in the runtime with the core team.
+ Shrink bundle size
  + Global initialization optimization (compiler)
  + Runtime Tag Matching (compiler)
  + Match Statement Optimization (compiler)
    + Alternatively we could replace some of the tag matching with `if` statements.

## Future Experiments
+ It would be interesting to allow some sort of colored printing.
  + I think the best way todo this would be to make a use a record pattern similar to the formatter and then shove an adapter in for coloring however that might not be as clean as doing it on a per token level.
    + The other downside to this approach is that it would probably bloat the binary quite a bit do to the indirection.
+ Allow for custom printing settings
  + Configuring cycle depth
    + This setting would allow us to specify how many times we would like to print a cyclic data structure before we start printing the cycle marker.
  + Configuring max depth
    + This setting would allow us to specify how deep we want to print nested data structures before we start printing a `<value>` marker, this is useful for preventing printing huge nested data structures that could bloat the output and make it hard to read.
  + indentation settings.
    + This setting would allow us to specify how many spaces should be used for indentation when printing nested data structures, this is useful for allowing users to customize the look of their printed data structures and make them more readable for their specific use case.
  + compact mode.
    + This setting would allow us to print data structures in a compact format, where they don't break I think this would just be a matter of setting the column width to infinite and disabling the line breaking rules.

# Licensing

This library is licensed under `GPL 3` as it makes use of the `doc.gr` library from the grain compiler, All code produced by spotandjake is licensed as `MIT`.

If a different document printing engine is used then `libs/doc.gr` this code can be distributed as `MIT`.