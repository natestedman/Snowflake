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

import ReactiveCocoa
import XCTest

class DeinitCallbackPropertyTableTests: XCTestCase
{
    func testReferences()
    {
        let table = DeinitCallbackPropertyTable<Int, Int>(withCache: false)
        
        // test that unretained properties are removed immediately
        table.propertyForKey(1, value: 0, replacing: false)
        XCTAssertEqual(table.table.count, 0)
        
        // test that retained properties are not removed
        var property = Optional.Some(table.propertyForKey(0, value: 0, replacing: false))
        XCTAssertEqual(table.table.count, 1)
        
        // test that properties that become unretained are removed
        property = nil
        XCTAssertEqual(table.table.count, 0)
        XCTAssertNil(property)
        
        // test that bound properties are not released
        var RACProperty: MutableProperty<Int?>? = MutableProperty(0)
        RACProperty! <~ table.propertyForKey(0, value: 0, replacing: false).producer
        XCTAssertEqual(table.table.count, 1)
        
        RACProperty = nil
        XCTAssertEqual(table.table.count, 0)
        XCTAssertNil(RACProperty)
    }
    
    func testCacheReferences()
    {
        let table = DeinitCallbackPropertyTable<Int, Int>(withCache: true)
        
        // test that unretained properties are not removed immediately
        table.propertyForKey(1, value: 0, replacing: false)
        XCTAssertEqual(table.table.count, 1)
        
        // test that retained properties are not removed
        var property = Optional.Some(table.propertyForKey(0, value: 0, replacing: false))
        XCTAssertEqual(table.table.count, 2)
        
        // test that properties that become unretained are not removed
        property = nil
        XCTAssertEqual(table.table.count, 2)
        XCTAssertNil(property)
        
        // test clearing cache
        table.cache?.removeAllObjects()
        XCTAssertEqual(table.table.count, 0)
    }
    
    func testUpdates()
    {
        let table = DeinitCallbackPropertyTable<Int, Int?>(withCache: false)
        
        // create a property
        let RACProperty = MutableProperty<Int?>(-1)
        XCTAssertEqual(RACProperty.value, -1)
        
        // bind the property to a property table
        RACProperty <~ table.propertyForKey(0, value: nil, replacing: false).producer.ignoreNil()
        XCTAssertEqual(RACProperty.value, -1)
        
        // update the value
        table.setValue(0, forKey: 0)
        XCTAssertEqual(RACProperty.value, 0)
    }
}
