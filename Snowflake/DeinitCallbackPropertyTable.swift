// Snowflake
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import Foundation
import ReactiveCocoa

/// A weakly referencing table of `DeinitCallbackProperty` objects.
internal class DeinitCallbackPropertyTable<Key: Hashable, Value>
{
    let cache: NSCache?
    
    init(withCache: Bool)
    {
        cache = withCache ? NSCache() : nil
    }
    
    /// A weak table to hold properties as long as they are retained elsewhere.
    let table = NSMapTable(keyOptions: .ObjectPersonality, valueOptions: .WeakMemory)
    
    /**
    Returns the `DeinitCallbackProperty` for a key, or creates it if necessary.
    
    - parameter key:       The key.
    - parameter value:     The value to update the property with.
    - parameter replacing: If `true`, `value` will be set over the current value of the property. If `false`, `value`
                           will only be used as an initial value if there is not currently a property for `key`.
    */
    func propertyForKey(key: Key, value: Value?, replacing: Bool) -> DeinitCallbackProperty<Value?>
    {
        let wrapper = HashableWrapper(wrapped: key)
        
        if let property = table.objectForKey(wrapper) as? DeinitCallbackProperty<Value?>
        {
            if replacing
            {
                property.value = value
            }
            
            return property
        }
        else
        {
            let property = DeinitCallbackProperty(initialValue: value, callback: { [weak self] in
                self?.table.removeObjectForKey(wrapper)
            })
            
            table.setObject(property, forKey: wrapper)
            cache?.setObject(property, forKey: wrapper)
            
            return property
        }
    }
    
    /**
    Updates the value for a specified key.
    
    - parameter value: The value to use.
    - parameter key:   The key to update.
    */
    func setValue(value: Value?, forKey key: Key)
    {
        propertyForKey(key, value: value, replacing: true)
    }
}
