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

class HashableWrapperTests: XCTestCase
{
    let wrapper1 = HashableWrapper(wrapped: "foo")
    let wrapper2 = HashableWrapper(wrapped: "bar")
    let wrapper3 = HashableWrapper(wrapped: "bar")
    
    func testIdentity()
    {
        XCTAssertFalse(wrapper1 === wrapper2)
        XCTAssertFalse(wrapper2 === wrapper3)
        XCTAssertFalse(wrapper1 === wrapper3)
    }
    
    func testEquality()
    {
        XCTAssertNotEqual(wrapper1, wrapper2)
        XCTAssertNotEqual(wrapper1, wrapper3)
        XCTAssertEqual(wrapper2, wrapper3)
    }
    
    func testHash()
    {
        XCTAssertNotEqual(wrapper1.hash, wrapper2.hash)
        XCTAssertNotEqual(wrapper1.hash, wrapper3.hash)
        XCTAssertEqual(wrapper2.hash, wrapper3.hash)
    }
    
    func testSet()
    {
        let set = NSMutableSet(capacity: 3)
        XCTAssertEqual(set.count, 0)
        
        set.addObject(wrapper1)
        XCTAssertEqual(set.count, 1)
        XCTAssertEqual(set, NSSet(array: [wrapper1]))
        
        set.addObject(wrapper2)
        XCTAssertEqual(set.count, 2)
        XCTAssertEqual(set, NSSet(array: [wrapper1, wrapper2]))
        
        set.addObject(wrapper3)
        XCTAssertEqual(set.count, 2)
        XCTAssertEqual(set, NSSet(array: [wrapper1, wrapper2]))
    }
}
