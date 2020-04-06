import XCTest
import DivideAndConquer

extension DivideAndConquer.ArraySlice {
  /// Scramble `self`, returning the number of reallocations due to COW, given
  /// that the storage of `self` was expected to match `expectedFootprint`.
  mutating func scramble(in expectedFootprint: ClosedRange<UnsafePointer<Element>>) -> Int {
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    var reallocations = expectedFootprint.contains(base) ? 0 : 1
    if count < 1 { return reallocations }
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

  static var allTests = [
      ("testExample", testExample),
  ]
}
