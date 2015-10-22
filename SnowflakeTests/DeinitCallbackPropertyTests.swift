// Snowflake
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

@testable import Snowflake

import XCTest

class DeinitCallbackPropertyTests: XCTestCase
{
    func testCallback()
    {
        var callback = false
        var property = DeinitCallbackProperty(initialValue: 0, callback: { callback = true })
        
        XCTAssertFalse(callback)
        property = DeinitCallbackProperty(initialValue: 1, callback: {})
        XCTAssertTrue(callback)
        
        // silences xcode warning
        XCTAssertEqual(property.value, 1)
    }
    
    func testProducerReference()
    {
        var callback = false
        var producer = Optional.Some(DeinitCallbackProperty(initialValue: 0, callback: { callback = true }).producer)
        XCTAssertFalse(callback)
        
        producer = nil
        XCTAssertTrue(callback)
        
        // silences xcode warning
        XCTAssertNil(producer)
    }
    
    func testDisposableReference()
    {
        var callback = false
        let disposable = DeinitCallbackProperty(initialValue: 0, callback: { callback = true }).producer.start()
        XCTAssertFalse(callback)
        
        disposable.dispose()
        XCTAssertTrue(callback)
    }
}
