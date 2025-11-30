# Grain String

This library is an experimental rewrite of grain's internal `toString` function, it is being designed as a standalone library with the future goal of being merged into the runtime.

## Why
One of grain's staple features is it's amazing `print` and `toString` function, that enables amazing developer experience. However the current `print` implementation starts to become messy when working with large dataStructures such as big lists, nested dataStructures and any other larger collection of data. This is mostly because of verboseness in the output large lists get printed on a single line which makes it hard to distinguish between 

## Design

I tried to design this library in a high level and user friendly way despite the low level needs of printing in grain, as such `toString` is mostly the formatting rules and layouts itself, while the layout rules are left to `libs/doc.gr` and the low level type reflection rules are left to `grainValue.gr`

### `libs/doc.gr`

This library comes from the grain compiler and is used internally for formatting grain code, which makes it a perfect candidate for formatting our printing settings with the same semantics. It is a highly fast pretty printing and document layout formatting engine that works in `o(n)` time. This is the key to the new printing semantics as it allows us to efficiently handle inserting line breaks and breaking logic in `o(n)` time, this also allows us to use similar pretty printing logic to what grain uses internally in the compiler allowing our printing formats to be consistent with our program formatting.

### `libs/grainValue.gr`

This library helps to abstract away a lot of the unsafe memory operations needed to inspect grains memory data, it is similar to a low level reflection api, and should make moving this library to wasm-gc a lot easier. The con of implementing things this way is it adds a lot of abstraction between printing and the data types likely increasing our bundle size which is why I hope to implement some of the upper level type matching into the compiler itself allowing safe type reflection in the runtime for free.  The other advantage to this approach is it makes maintaining this library and any other unsafe library far easier as we just update the `grainValue` types and exhaustiveness will tell us if we are handling things or not, hopefully preventing issues in the future.

## Size

As the goal is to include this in the standard library it is critical that we keep the bundle size of this library low, hence why regular stdlib libraries have been replaced where possible with smaller and purpose built alternatives such as `MiniBuffer`. Currently we are `1.8x` larger on our smallest `Hello World` program and I think we can get that within `1.5x` with some more work, before moving this work into the runtime It would be nice to have a conversation about the future of `grainValue` and the purpose of `doc.gr` as we could make it more purpose built or we could keep it generic and use it for other libraries such as `json`, `yaml`, `markdown` and other stdlib libraries.


## Still To Be Done
+ Nested Testing
  + Test more complex nesting scenarios
  + Test more complex cycle scenarios
+ Elided Type Info Testing
+ Performance Testing
+ Discuss implementing this in the runtime with the core team.
+ Determine fate of `grainValue.gr`
  + My goal is to upstream some of this into the compiler [see here](https://github.com/grain-lang/grain/issues/2208). This will make such abstractions almost free.
  + If that doesn't work I think we are going to need to strip out the implementation and put the logic back into `toString` itself to reduce some of the size overhead.
+ Shrink bundle size
  + Wasm-gc should shrink this significantly (compiler)
  + Global initialization optimization (compiler)
  + Determining the fate of `grainValue.gr` should shrink things (possibly compiler)
+ Fully Document `doc.gr`
+ Fully Document `toString.gr`
+ Fully Document `grainValue.gr`

## Future Experiments
+ It would be interesting to allow some sort of colored printing.
  + I think the best way todo this would be to make a use a record pattern similar to the formatter and then shove an adapter in for coloring however that might not be as clean as doing it on a per token level.
+ Allow for custom printing settings
  + line break settings
  + indentation settings.
  + compact mode.

# Licensing

This library is licensed under `GPL 3` as it makes use of the `doc.gr` library from the grain compiler, All code produced by spotandjake is licensed as `MIT`.

If a different document printing engine is used then `libs/doc.gr` this code can be distributed as `MIT`.