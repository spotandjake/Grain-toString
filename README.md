# Grain String

This library is an experimental rewrite of grain's internal `toString` function, it is being designed as a standalone library with the future goal of being merged into the runtime. 

This library has been developed and is maintained for `0.8.x`.

## Why
One of grain's staple features is it's amazing `print` and `toString` function, that enables an amazing developer experience. However the current `print` implementation suffers from a few issues, the current implementation is written in an extremely low level manner with no separation of concerns, in `runtime/string` we currently handle printing, walking the print structure and cycle detection which are all tightly linked due to the low level nature of this module it can be hard to read, understand and maintain without being extremely familiar with grains internal data structures and printing logic. Beyond this the output starts to become messy when working with large dataStructures, big lists beyond a certain number of items don't line break which makes them hard to understand.

The problems we are trying to solve with this library are as follows:
* Separation of concerns, keep the printing logic separate from the formatting logic, and the formatting logic separate from the type reflection logic.
* Use zero cost abstracts to allow us to work at a higher level of abstraction without sacrificing on performance and bundle size.
* Use a proper pretty printer and document layout engine to allow us to efficiently format our output to the same standard as grain code itself.
* Try to expose individual printers for different data structures allowing us to provide more specialized and faster printers for certain data structures such as `Number`, `String` and `List`.
  * This can be used in the future to help monomorphize calls to `toString` and `print` in the compiler by replacing them with the specific printers.
  * This can be used right now to provide fast alternatives to the general `toString` in each module such as `List.toString` or `Number.toString` without having to duplicate the entire `toString` logic in each module.

## Design

In order to achieve the goals outlined above, I have designed this library to be modular, this has many benefits, firstly it allows us to use abstract types to provide clean high level API's while keeping the implementations themselves low level and efficient, secondly it allows each module to be focused on a specific concern making maintance easier, and thirdly it means we are adding some new extremely helpful utility libraries to the runtime.

### `libs/doc.gr`

This library is the core of the new printing algorithm, it started as a direct port of the `doc.gr` library from the grain formatter but has since been heavily optimized to support runtime printing (large data structures, size constraints). It maintains the same benefit as before however that it can handle printing and formatting decisions in `o(n)` time which is crucial for printing large data structures. As it is the same library used in the grain formatter we also benefit from the standardization we can use the exact same formatting logic as the formatter itself which means our runtime printing will be consistent with how grain code is formatted which is a wonderful bonus.

While the internals of the module have been optimized for runtime printing, the public API has been kept pretty much the same this means that we can easily use this module for pretty printing in other built in libraries such as `json` currently and in the future `markdown`, `yaml`, `toml` or any other library that we may want, we could also consider exposing this module to users directly for pretty printing their own data structures.

The optimizations that have been made vary the main one is that previously we stack overflowed on large iterables due to concat being non tail recursive, there wasn't really a good way around this with a recursive approach so I switched to using a work queue which allows us to print large iterables without worrying about stack overflows, from my testing printing `100k` item arrays is pretty much instantaneous though do to the amount of work being done and memory pressure performance seems to degrade after around `2 million` items (keep in mind this is a stress test and most programs won't be printing that many items, nor expecting them to print instantly, even still we currently manage to achieve printing `1 million` items in less than `10s` in debug mode).

### `libs/grainValue.gr`

In the intial implementation this library was responsible for a lot of the type reflection however it has been stripped down to just contain tag checks for performance and size reasons, the idea would be to merge these checks into `runtime/dataStructures.gr`, this helps to abstract away a lot of the tag checking logic and standardize it across the entire runtime, which keeps the printing logic much cleaner. I still think that my [runtime tag matching](https://github.com/grain-lang/grain/issues/2208) proposal would be a good addition to the language as it would allow us to check tags exhaustively with 0 overhead given it could just produce a switch, from my initial test implementation it also doesn't add much compiler maintenance burden and it should be even simpler to implement now with wasm gc.

### `libs/miniBuffer.gr`

This library implements a simple mutable buffer stripped of user experience features which lowers the bundle size compared to the regular buffer library, we've needed this library for a while now and had an issue open to take advantage of buffers throughout the stdlib in places like `List.toString`.

### `libs/Vector.gr`

This library implements a simple mutable vector following a very similar implementation to our current cycle detection vector in `runtime/string` it seems useful as a utility library on it's own.

As a note there are some changes here, we use this both for the workQueue implementation in `doc.gr` and the cycle tracking implementation in `toString.gr` while cycles grow slowly the workQueue grows quick and often follows the pattern that your either printing something small, medium or large. Which means that there isn't much in between hence the initial size is `8` instead of `4` which allows printing small data structures without any resizing, the growth rate has been modified from `x2` to `x4` which means we are reallocating less often when printing large data structures under the assumption that the user probably isn't as memory constrained if they are printing a large data structure and would prefer faster printing.

## Size

One of the key goals of this rewrite was to keep the bundle size low while packing in as much functionality as possible. There is a reason that most runtime printers avoid including a pretty printing library as they often are quite large however with the current implementation we are able to add all of this functionality while only increasing bundle size by `1.37x` or approximately `6kb` when compiled in release mode with type info elided this means that currently without any monomorphization an optimized hello world program is below `21kb` vs the `14kb` it was previously. Some notes here, the size increase is mostly due to the amount of pattern matching and enum usage in `doc.gr` which could be optimized further however it would make the code a lot lower level and harder to maintain so it doesn't seem worth it from some experimenting it seems that we could reduce size a lot with some simple compiler optimizations, `runtime type matching`, `match statement optimizations`, `enum simplification` and `global initialization optimizations` all of which would help both this implementation and every other high level grain module. Beyond this it's important to note that a lot of the module size itself comes from `malloc` for wasi (exceptions, printing) which means in an actual program do to code re-use the size overhead is likely to be much smaller than `6kb` as we are already using a lof of the same runtime code throughout the stdlib.

## Performance

Another goal of this rewrite was to provide extremely fast performance, and it seems that we have achieved this goal in the general case, as can be seen by running `perf.gr` we can print a million items in around `9s` in debug mode and around `7s` in release mode which is pretty good considering the amount of work being done and the fact that this is a stress test, most programs won't be printing millions of items at a time, and instead will be printing smaller data structures where the overhead is negligible, it may even be worth considering setting a `MAX_ITEM_COUNT` for printing where we cutoff iterables as the formatting is impractical anyways. Even `100k` items printing is pretty much instantaneous. Some of the size optimzations mentioned above would also greatly help here and the current split seems to put us at about `40%` of program time on a 1million item array being constructing the doc tree and `60%` of the time being spent printing the doc tree, this split reveals that there is still room left to optimize on performance, we can add a `Repeat` or `ConcatArray` node to the doc tree which would help to avoid a lot of node creation and queue operations.

## Modular

One major difference between this library and the current `toString` implementation is that individual printers for each dataStructure is now it's own concept which allows us to provide faster more specialized printers for certain dataStructures such exposing a `Number.toString`, `String.toString` and `List.toString`, further to this we could have the compiler monomorphize calls to `toString` and `print` by replacing the calls with the specific printers. 

## Testing

Tests for this library can be found in `test/toString.test.gr` and `test/toStringNoTypeInfo.test.gr` these tests cover basically every case we run into while printing and is already more comprehensive than the current tests for `toString` in `runtime/string` however there is still more testing that can be done, especially around more complex nesting scenarios.

## Still To Be Done
+ Tests
  + Test more complex nesting scenarios
+ Discuss implementing this in the runtime with the core team.
+ Shrink bundle size
  + Global initialization optimization (compiler)
  + Runtime Tag Matching (compiler)
  + Match Statement Optimization (compiler)

## Future Experiments
+ It would be interesting to allow some sort of colored printing.
  + I think the best way todo this would be to make a use a record pattern similar to the formatter and then shove an adapter in for coloring however that might not be as clean as doing it on a per token level.
    + The other downside to this approach is that it would probably bloat the binary quite a bit do to the indirection.
+ Allow for custom printing settings
  + Configuring cycle depth
    + This setting would allow us to specify how many times we would like to print a cyclic data structure before we start printing the cycle marker.
  + indentation settings.
    + This setting would allow us to specify how many spaces should be used for indentation when printing nested data structures, this is useful for allowing users to customize the look of their printed data structures and make them more readable for their specific use case.
  + compact mode.
    + This setting would allow us to print data structures in a compact format, where they don't break I think this would just be a matter of setting the column width to infinite and disabling the line breaking rules.

# Licensing

This library is licensed under `GPL 3` as it makes use of the `doc.gr` library from the grain compiler, All code produced by spotandjake is licensed as `MIT`.

If a different document printing engine is used then `libs/doc.gr` this code can be distributed as `MIT`.