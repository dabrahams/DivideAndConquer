import DivideAndConquerShims

@inlinable
func isDuallyReferenced(_ o: inout AnyObject) -> Bool {
  let rawHeapObject
      = unsafeBitCast(o, to: UnsafeMutablePointer<HeapObject>?.self)
  return swift_isDuallyReferenced(rawHeapObject) != 0
}

@inlinable
func strongRefCount(_ o: inout AnyObject) -> UInt32 {
  let rawHeapObject
      = unsafeBitCast(o, to: UnsafeMutablePointer<HeapObject>?.self)
  return swift_strongRefCount(rawHeapObject)
}
