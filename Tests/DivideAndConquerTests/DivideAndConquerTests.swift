import XCTest
//@testable
import DivideAndConquer

func indent(_ depth: Int) -> String {
  repeatElement(" ", count: depth).joined()
}

extension DivideAndConquer.ArraySlice {
  mutating func scramble(
      depth: Int, noCOW: ClosedRange<UnsafePointer<Element>>
  ) -> Int {
    var reallocations = 0
    // print(indent(depth), "scramble(\(startIndex)..<\(endIndex))")
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    if (!noCOW.contains(base) || !noCOW.contains(base+count)) {
      reallocations = 1
    }
    if count < 1 { return reallocations }
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
    }
    else {
      let noCOW = base...(base+count)
      let m = (startIndex + endIndex) / 2
      reallocations +=
      self[startIndex..<m].scramble(depth: depth + 1, noCOW: noCOW)
      reallocations +=
      self[m..<endIndex].scramble(depth: depth + 1, noCOW: noCOW)
    }
    return reallocations
  }

  mutating func scramble() -> Int {
    if count < 1 { return 0 }
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    let noCOW = base...base + count
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
      return 0
    }
    else {
      let m = (startIndex + endIndex) / 2
      let r0 = self[startIndex..<m].scramble(depth: 0, noCOW: noCOW)
      let r1 = self[m..<endIndex].scramble(depth: 0, noCOW: noCOW)
      return r0 + r1
    }
  }
}


extension DivideAndConquer.ContiguousArray {
  mutating func scramble() -> Int {
    if count < 1 { return 0 }
    let base = withUnsafeBufferPointer { $0.baseAddress! }
    let noCOW = base...base + count
    if count < 4 {
      swapAt(startIndex, endIndex - 1)
      return 0
    }
    else {
      let m = (startIndex + endIndex) / 2
      return
          self[startIndex..<m].scramble(depth: 0, noCOW: noCOW)
          + self[m..<endIndex].scramble(depth: 0, noCOW: noCOW)
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
