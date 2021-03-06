import XCTest

class DetectTests: XCTestCase {

  func testReturnsTruthyItem() {
    func trueIfHappy(text: String, callback: (NSError?, Bool) -> ()) {
      callback(nil, text == "happy")
    }

    Async.detect(["happy", "sad"], iterator: trueIfHappy) { err, result in
      XCTAssertEqual(result, "happy")
    }
  }

  func testBreaksOnTruth() {
    var called = 0

    func sadSlow(text: String, callback: (NSError?, Bool) -> ()) {
      if text == "sad" {
        delay(100)
      }

      called += 1
      callback(nil, text == "happy")
    }

    Async.detect(["happy", "sad", "sad"], iterator: sadSlow) { err, result in
      XCTAssertLessThan(called, 3)
    }
  }

  func testRunsInParallel() {
    var called = 0

    func throttle(speed: String, callback: (NSError?, Bool) -> ()) {
      if speed == "slow" {
        delay(100)
      }

      called += 1
      callback(nil, speed == "fast")
    }

    Async.detectSeries(["slow", "fast", "slow"], iterator: throttle) { err, result in
      XCTAssertEqual(called, 2)
    }
  }

}
