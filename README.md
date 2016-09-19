# BGRecursiveTableViewDataSource
Recursive “stacking” and modularization of `UITableViewDataSource(s)`

[![Version](https://img.shields.io/cocoapods/v/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![License](https://img.shields.io/cocoapods/l/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)

## Overview

`UITableViewDataSource(s)` for more complicated views (consider **the "Settings" app on iOS**, for example) can be complex and difficult to maintain. Displaying multiple sections with varying content that is perhaps dynamic often without "spaghetti code" is essential.

One strategy for managing varying sections of content that are both static and dynamic is by using `BGRecursiveTableViewDataSource`. This library allows you to build **modular, subclassable `UITableViewDataSource(s)` and group them together dynamically** for use with `UITableViewController(s)` easily.

It also includes native support for **`NSFetchedResultsController`** via an optional subclass.

## Introducing Toggleable, Recursive “Subsections”

The simplest application of `BGRecursiveTableViewDataSource` is without any recursion or "subsections". However, if you want toggleable or dynamic subsections that appear or disappear with the touch of a switch (for example), you may find the subsection functionality to be useful.

Subsections allow you to **“pin” a `BGRecursiveTableViewDataSourceSectionGroup`** (`UITableViewDataSource` subclass) to an `NSIndexPath` within another `BGRecursiveTableViewDataSourceSectionGroup`, recursively. You may have it appear/disappear with a method call at any level in your top-level `BGRecursiveTableViewDataSource`, and its initial state of being expanded or hidden is configurable.

------------------------------------------------------------------

*More to come...*


## Installation

`BGRecursiveTableViewDataSource` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BGRecursiveTableViewDataSource"
```

## Author

Ben Guild, email@benguild.com

## License

`BGRecursiveTableViewDataSource` is available under the MIT license. See the LICENSE file for more info.
