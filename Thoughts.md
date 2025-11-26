# Grain Proposal

This is just a basic work in progress of collection of thoughts for moving this work into grain.


I think we can greatly simplify `grainValue` and move some of it's features into the langauge itself it would be very easy to remove or slim down the benefit of this is just type safety outside when we update primitives.

I would like to experiment with implementing a compact `toString` mode along with an unformatted string mode.

I was thinking it may be interesting to experiment with a similar record pattern to what we use in the formatter I was thinking for adding coloring support we can just throw an adapter in between that wraps the formatting functions with coloring, this wouldn't be on by default but I would love if we could toggle it on.

I think we should discuss if `print` belongs in the runtime or stdlib? The benefit to having it in the runtime right now is that we can consume print anywhere in the runtime for debugging however I think it would actually make sense to move it back into the standard library itself especially if we use something like `grainValue` that let's us abstract away, I think in the runtime it might make sense to have simplified printing utilities like we currently do in `DebugPrint`.

One downside of this change is we are making print quite a bit larger considering we have to build an entire ast, performance wise I don't think this is too much of a problem we are still `O(n)` with less reallocations occuring on large nested data structures, though our simple cases will be a bit slower, by larger concern would be program size, this would bloat a decent bit just with some early testing I saw a change from `29.4kB` to `151.9kB` kb which is a rather large increase in size, I do however think this trade off is worth it maybe with an optimization to use a simplistic direct write in the simple case of `print(String)`, I also think we can greatly reduce that 151kB with some smart optimizations, and wasm-gc should make this difference quite a bit less.