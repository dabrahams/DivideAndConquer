import XCTest
//@testable
import DivideAndConquer

class Box<T> {
  init(_ x: T) { self.x = x }
  var x: T
}

var escape: Any?

extension DivideAndConquer.ArraySlice {
  /// Scramble `self`, returning the number of reallocations due to COW, given
  /// that the storage of `self` was expected to match `expectedFootprint`.
  mutating func scramble(
      in expectedFootprint: ClosedRange<UnsafePointer<Element>>) -> Int
  {
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    var reallocations = expectedFootprint.contains(base) ? 0 : 1
    if count < 1 { return reallocations }
    if escape != nil && count > 1 {
      var x = self
      x[0] = x[1]
    }
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
    }
    else {
      let footprint = base...(base+count)
      let m = (startIndex + endIndex) / 2
      reallocations += self[startIndex..<m].scramble(in: footprint)
      reallocations += self[m..<endIndex].scramble(in: footprint)
    }
    return reallocations
  }

  /// Scramble `self`, returning the number of reallocations due to COW.
  mutating func scramble() -> Int {
    if count < 1 { return 0 }
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    let footprint = base...base + count
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
      return 0
    }
    else {
      let m = (startIndex + endIndex) / 2
      let r0 = self[startIndex..<m].scramble(in: footprint)
      let r1 = self[m..<endIndex].scramble(in: footprint)
      return r0 + r1
    }
  }
}

extension ContiguousArray {
  /// Scramble `self`, returning the number of reallocations due to COW.
  mutating func scramble() -> Int {
    if count < 1 { return 0 }
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    let footprint = base...base + count
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
      return 0
    }
    else {
      let m = (startIndex + endIndex) / 2
      let r0 = self[startIndex..<m].scramble(in: footprint)
      let r1 = self[m..<endIndex].scramble(in: footprint)
      return r0 + r1
    }
  }
}

final class DivideAndConquerTests: XCTestCase {
  func testExample() {
    var a = DivideAndConquer.ContiguousArray(0..<500)
    let reallocs = a.scramble()
    XCTAssertEqual(reallocs, 0)
  }

  // Demonstrate semantics work and there are no over-releases even when the
  // array escapes.
  func testEscape() {
    // Baseline
    var a0 = DivideAndConquer.ContiguousArray(0..<500)
    let reallocs0 = a0.scramble()
    XCTAssertEqual(reallocs0, 0)
    
    escape = 1 // turn on escaping
    let reallocs: Int
    do {
      var a = DivideAndConquer.ContiguousArray(0..<500)
      reallocs = a.scramble()
      escape = nil
      XCTAssert(a.elementsEqual(a0))
    }
    XCTAssertNotEqual(reallocs, 0)
  }
  
  func testB() {
    var b = DivideAndConquer.ContiguousArray(0..<10)
    b[9..<10].append(10)
    XCTAssert(b.elementsEqual(0...10))
    b[3..<4] += 66...68
    XCTAssert(b[0..<4].elementsEqual(0..<4))
    XCTAssert(b[4..<7].elementsEqual(66...68))
    XCTAssert(b[7...].elementsEqual(4...10))
  }

  static var allTests = [
      ("testExample", testExample),
  ]
}
