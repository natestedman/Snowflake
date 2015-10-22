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

struct TestModel: Unique
{
    typealias UniqueKey = Int
    
    let identifier: UniqueKey
    let value: Int
    
    var uniqueKey: UniqueKey
    {
        return identifier
    }
}

class UniqueTableTests: XCTestCase
{
    func testUniqueTable()
    {
        let table = UniqueTable<TestModel.UniqueKey, TestModel>()
        
        // bind property to unique table
        let property = MutableProperty(TestModel?.None)
        property <~ table.producerForKey(0)
        XCTAssertEqual(property.value?.value, nil)
        
        // change value
        table.updateValue(TestModel(identifier: 0, value: 0))
        XCTAssertEqual(property.value?.value, 0)
        
        table.updateValue(TestModel(identifier: 0, value: 1))
        XCTAssertEqual(property.value?.value, 1)
        
        // don't change value
        table.updateValue(TestModel(identifier: 1, value: 2))
        XCTAssertEqual(property.value?.value, 1)
    }
}
