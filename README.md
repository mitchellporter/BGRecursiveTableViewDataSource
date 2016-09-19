# BGRecursiveTableViewDataSource
Recursive “stacking” and modularization of `UITableViewDataSource(s)` with Apple iOS's `UIKit`

**Documentation and demo are a work in process,** but Cocoa Pod is stable.

[![Version](https://img.shields.io/cocoapods/v/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![License](https://img.shields.io/cocoapods/l/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)

## Overview

**This module allows you to stack multiple `UITableViewDataSource(s)` in a single `UITableViewController` or `UITableView`, and manage them dynamically.** [Core Data](https://en.wikipedia.org/wiki/Core_Data) and [NSFetchedResultsController](https://developer.apple.com/reference/coredata/nsfetchedresultscontroller) are supported.

`UITableViewDataSource(s)` for more complicated views (consider **the "Settings" app on iOS**, for example) can be complex and difficult to maintain. Displaying multiple sections with varying and often dynamic content is necessary, yet so is avoiding "spaghetti code" that requires dissection and complex testing for changes.

![Imagine trying to maintain `UITableViewDataSource(s)` like this!](https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/demo.png "Imagine trying to maintain `UITableViewDataSource(s)` like this!")

> **... Imagine trying to maintain complex/dynamic `UITableViewDataSource(s)` like this one!**

One strategy for managing varying sections of content that are both static and dynamic is by using `BGRecursiveTableViewDataSource`. This module allows you to build **modular, subclassable `UITableViewDataSource(s)` and group them together dynamically** for use with one or more `UITableViewController(s)` easily.

## Introducing Toggleable, Recursive “Subsections”

The simplest application of `BGRecursiveTableViewDataSource` is without any recursion or "subsections". However, if you want toggleable or dynamic subsections that appear or disappear with the touch of a switch (for example), you may find the subsection functionality to be useful.

Subsections allow you to **“pin” a `BGRecursiveTableViewDataSourceSectionGroup`** (`UITableViewDataSource` subclass) to an `NSIndexPath` within another `BGRecursiveTableViewDataSourceSectionGroup`, recursively. You may have it appear/disappear with a method call at any level in your top-level `BGRecursiveTableViewDataSource`, and its initial state of being expanded or hidden is configurable.

## Accessing Top-Level `NSIndexPath(s)` and Resolving Subsections

From the top-level, you can resolve the actual "sectionGroup" and "indexPath" of that `UITableViewDataSource`:

```objc
- (id)resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath))matchBlock;
```

From section groups themselves, you can resolve the top-level "indexPath" as well:

```objc
- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath forTopLevelSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
```

**For other useful methods,** see the header files of each of the bundled classes.

## Core Data & `NSFetchedResultsController`

If you’re using Apple's [Core Data](https://en.wikipedia.org/wiki/Core_Data), you probably already know what you’re doing. Support for this is built-in using a provided subclass. Check out the “Example” project bundled with this pod/repo, and imagine subclassing and initializing **`BGRecursiveTableViewDataSourceFetchedResultsSectionGroup`** instead with a `NSFetchedResultsController` as a property.

There are some **additional methods available** for this subclass, so check out its header file.

Last, **an additional subclass variant** besides the standard one for `NSFetchedResultsController` is available: `BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup` — This subclass will create **empty sections** based on the `NSFetchedResultsController` content. You can fill these with static or other content as you wish.

## Debugging Tips

If you run into a crash or exception, try disabling one or more of your section groups or their subsections.

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
