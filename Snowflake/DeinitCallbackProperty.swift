// Snowflake
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import ReactiveCocoa

/// A property that executes a callback when it deinits.
internal class DeinitCallbackProperty<Value>: PropertyType
{
    /**
    Initializes a `DeinitCallbackProperty`.
    
    - parameter initialValue: The initial value of the property.
    - parameter callback:     A callback to execute when the property deinits.
    */
    init(initialValue: Value, callback: () -> ())
    {
        self.backing = MutableProperty(initialValue)
        self.callback = callback
    }
    
    deinit
    {
        callback()
    }
    
    /// The callback to execute when this object deinits.
    let callback: () -> ()
    
    /// The backing property for this property.
    private let backing: MutableProperty<Value>
    
    /// The current value of the property.
    var value: Value
    {
        get
        {
            return backing.value
        }
        set(newValue)
        {
            backing.value = newValue
        }
    }
    
    /// A signal producer for the property's value.
    var producer: SignalProducer<Value, NoError>
    {
        // create a retain cycle, ensuring this property stays alive while anything is referencing its producer.
        return backing.producer
            .on(completed: { self })
    }
}
