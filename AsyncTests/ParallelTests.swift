import XCTest

class ParallelTests: XCTestCase {

  func testPreservesOrder() {
    Async.parallel([slow, fast]) { err, results in
      XCTAssertEqual([results[0].text, results[1].text], ["slow", "fast"])
    }
  }

  func testRunsInParallel() {
    Async.parallel([slow, fast]) { err, results in
      XCTAssertGreaterThan(results[0].time, results[1].time)
    }
  }

  // Helpers

  private func fast(callback: (NSError?, (text: String, time: NSTimeInterval)) -> ()) {
    callback(nil, ("fast", NSDate().timeIntervalSince1970))
  }

  private func slow(callback: (NSError?, (text: String, time: NSTimeInterval)) -> ()) {
    delay(100)
    callback(nil, ("slow", NSDate().timeIntervalSince1970))
  }

}
