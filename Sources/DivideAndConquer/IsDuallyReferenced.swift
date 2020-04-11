import DivideAndConquerShims

/// Returns true iff there are exactly two strong references to `o`.
@inlinable
func isDuallyReferenced(_ o: inout AnyObject) -> Bool {
  let rawHeapObject
      = unsafeBitCast(o, to: UnsafeMutablePointer<HeapObject>?.self)
  return swift_isDuallyReferenced(rawHeapObject) != 0
}

/// Returns the number of strong references to `o`.
///
/// Not currently used in the demo, but can be useful for diagnostic purposes.
@inlinable
func strongRefCount(_ o: inout AnyObject) -> UInt32 {
  let rawHeapObject
      = unsafeBitCast(o, to: UnsafeMutablePointer<HeapObject>?.self)
  return swift_strongRefCount(rawHeapObject)
}
