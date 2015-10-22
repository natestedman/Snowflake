// Snowflake
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

/// A type with enhanced support for `UniqueTable`.
///
/// It is not necessary to conform to this protocol to use `UniqueTable`.
public protocol Unique
{
    /// The type of the unique type's unique key.
    typealias UniqueKey: Hashable
    
    /// The unique key for this value.
    var uniqueKey: UniqueKey { get }
}
