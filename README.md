# DivideAndConquer

Shows how we can resolve the problem where mutating divide-and-conquer
algorithms cause COW (https://bugs.swift.org/browse/SR-12524)

I started by importing as much of `ContiguousArray`/`ContiguousArraySlice` as I
could from the standard library and running the test against that.

The changes made since that point are in
https://github.com/dabrahams/DivideAndConquer/compare/bug-demo...master

