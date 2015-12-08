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

/// A table of unique values, identified by a `Hashable` key, and observable with ReactiveCocoa.
public final class UniqueTable<Key: Hashable, Value>
{
    // MARK: - Initialization
    
    /**
    Initializes a unique table.
    
    - parameter withCache: If `true`, unique values will be cached with `NSCache`. If `false`, they will be removed once
                           there are no strong references to a signal producer for the value's key. If this parameter
                           is omitted, values will not be cached.
    */
    public init(withCache: Bool = false)
    {
        table = DeinitCallbackPropertyTable<Key, Value>(withCache: withCache)
    }
    
    /// The unique table.
    private let table: DeinitCallbackPropertyTable<Key, Value>
}

extension UniqueTable
{
    // MARK: - Updating Values
    
    /**
    Updates the value for a specified key.
    
    - parameter value: The new value.
    - parameter key:   The key to update.
    */
    public func updateValue(value: Value, forKey key: Key)
    {
        table.setValue(value, forKey: key)
    }
    
    // MARK: - Retrieving Values
    
    /**
    Returns the current value for a key, if any.
    
    - parameter key: The key.
    */
    public subscript(key: Key) -> Value?
    {
        get
        {
            return table.propertyForKey(key)?.value
        }
    }
}

extension UniqueTable
{
    // MARK: - Producers
    
    /**
    Returns a property for the specified key, initializing the unique value if necessary.
    
    - parameter key:          The key to return a producer for.
    - parameter initialValue: The initial value. This parameter only applies to unique values that have not already been
                              initialized - if a value already exists, it will not be overwritten.
    */
    @warn_unused_result
    public func propertyForKey(key: Key, initialValue: Value) -> AnyProperty<Value>
    {
        return AnyProperty(
            initialValue: initialValue,
            producer: table.propertyForKey(key, value: initialValue, replacing: false).producer.ignoreNil()
        )
    }
    
    /**
    Returns a property for the specified key, after updating with the specified value.
    
    - parameter key:          The key to return a property for.
    - parameter updatedValue: The updated value.
    */
    @warn_unused_result
    public func propertyForKey(key: Key, updatedValue: Value) -> AnyProperty<Value>
    {
        return AnyProperty(
            initialValue: updatedValue,
            producer: table.propertyForKey(key, value: updatedValue, replacing: true).producer.ignoreNil()
        )
    }
    
    /**
     Returns a signal producer for the specified key, with an optional type. In this case, it is not necessary to
     provide an initial or updated value.
     
     - parameter key: The key to return a signal producer for.
     */
    @warn_unused_result
    public func optionalProducerForKey(key: Key) -> SignalProducer<Value?, NoError>
    {
        return table.propertyForKey(key, value: nil, replacing: false).producer
    }
}

public extension UniqueTable where Key == Value.UniqueKey, Value: Unique
{
    // MARK: - Unique
    
    /**
    Updates a unique value's unique key.
    
    - parameter value: The new unique value.
    */
    public func updateValue(value: Value)
    {
        updateValue(value, forKey: value.uniqueKey)
    }
    
    /**
    Updates a unique value, and returns a signal producer for its unique key.
    
    - parameter value: The new unique value.
    */
    @warn_unused_result
    public func propertyForUpdatedValue(value: Value) -> AnyProperty<Value>
    {
        return propertyForKey(value.uniqueKey, updatedValue: value)
    }
}
