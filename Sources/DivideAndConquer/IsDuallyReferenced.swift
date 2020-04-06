import DivideAndConquerShims

@inlinable
func isDuallyReferenced(_ o: inout AnyObject) -> Bool {
  let rawHeapObject
      = unsafeBitCast(o, to: UnsafeMutablePointer<HeapObject>?.self)
  return swift_isDuallyReferenced(rawHeapObject) != 0
}
