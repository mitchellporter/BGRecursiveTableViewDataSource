# BGRecursiveTableViewDataSource
Recursive “stacking” and modularization of `UITableViewDataSource(s)` with Apple iOS's `UIKit`.

[![Version](https://img.shields.io/cocoapods/v/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![License](https://img.shields.io/cocoapods/l/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)

### Some other helpful Cocoa Pods:
- **`BGPersistentStoreManager`** ([link](https://github.com/benguild/BGPersistentStoreManager)) — A simple singleton/wrapper/manager for the Apple iOS/macOS/etc. "Core Data" `NSPersistentStore` object/contexts.
- **`BGTableViewRowActionWithImage`** ([link](https://github.com/benguild/BGTableViewRowActionWithImage)) — A variation on the iOS 8.0+ `UITableViewRowAction` to support icons, with text below. Similar to the iOS 9 Mail application and various third-party applications.

## Objective

To provide a lightweight module for the vertical stacking and dynamic toggling of existing, modular **`UITableViewDataSource` implementations** for a `UITableView` and `UITableViewController`, while making as few (if any) changes to `UITableViewDataSource` as possible.

## Implementation

**This module provides a liason between multiple stacked or "pinned" `UITableViewDataSource(s)` for use on a single `UITableView` or `UITableViewController`.** It also includes support for using `NSFetchedResultsController` with [Core Data](https://en.wikipedia.org/wiki/Core_Data) on a range of sections or subsections in a `UITableView`, rather than on the entire thing.

![Structural usage diagram](https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/diagram.png "Structural usage diagram")

With this module, adding toggleable subsections using switches and reusing "blocks" of `UITableView` data throughout your app becomes much easier and more straightforward, while retaining familiarity through the implementation of the well-known `UIKit` protocol, **`UITableViewDataSource`**.

![Imagine trying to maintain `UITableViewDataSource(s)` like this!](https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/demo.png "Imagine trying to maintain `UITableViewDataSource(s)` like this!")

> **`UITableViewDataSource(s)` for more complicated views (like the "Settings" app on iOS, for example) can be complex and difficult to maintain.** Making changes to an implementation of this while using stacked data sources and `BGRecursiveTableViewDataSource` is much more straightforward, thanks to modularization and code re-use.

This module allows you to build **modular, subclassable `UITableViewDataSource` implementations and group them together dynamically** for use with one or more `UITableViewController(s)` easily, WITHOUT the "spaghetti code" that requires dissection and complex testing during revision or bug-fixes. Support for the dynamic adding and removal of entire `UITableViewDataSource` stacks is supported!

## Support methods

Part of the simplicity of this implentation comes from the reuse of `UITableViewDataSource` for groups of `UITableView` sections or subsections. If the code within your **`BGRecursiveTableViewDataSourceSectionGroup`** (implementing `UITableViewDataSource`) needs to resolve its top-level `NSIndexPath` from its internal, offset `NSIndexPath` (based on its rows and sections' overall position given other prior sections from any other preceding section groups), this can be accomplished by calling this method on the `BGRecursiveTableViewDataSourceSectionGroup` itself:

```objc
- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath;
```

Convenience methods for inserting, reloading, or deleting rows and sections dynamically (and also beginning/ending updates on the `BGRecursiveTableViewDataSourceSectionGroup(s)` themselves) are provided simply by **calling said methods on the `BGRecursiveTableViewDataSourceSectionGroup(s)`** rather than on the `UITableView` directly:

```objc
- (void)beginUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)priorSectionGroups; // Use these internally instead of calling `UITableView` beginUpdates/endUpdates() methods.
- (void)endUpdatesForSectionGroups:(NSSet <BGRecursiveTableViewDataSourceSectionGroup *>*)priorSectionGroups;

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
```

It is possible to do this yourself in a simple, single-level implementation using `translateInternalIndexPathToTopLevel:indexPath:` and then calling the appropriate methods on your `UITableView`, but when using subsections in any section group, there is some internal mapping/shifting of indexes required. These methods will take care of that for you.

### Inserting or Removing Entire Section Groups

You can add/remove entire blocks of sections and their subsections by calling these methods on the `BGRecursiveTableViewDataSource`:

```objc
- (void)insertSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup atIndexForSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroupForIndex insertAfter:(BOOL)insertAfter;
- (void)removeSectionGroupAndItsDisplayedSections:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
```

**During the initial loading of the `BGRecursiveTableViewDataSource` only (before the `UITableView` has loaded or displayed any data),** section groups can and should simply be appended:

```objc
- (void)appendSectionGroupToNewDataSource:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
```

### Recursion

All methods are designed to work both on top-level sections and their subsections at multiple levels, hence the "recursive" nature and design of the module. However, keep in mind that each level of recursion bears some compounding performance overhead. Unnecessary recursion should be avoided to ensure both optimal scrolling-performance at run-time and the optimal code organization/structure benefits from this module.

Enhancements and optimizations to the codebase are always welcome.

## Introducing Toggleable, Recursive “Subsections”

The simplest application of `BGRecursiveTableViewDataSource` is without any recursion or "subsections". However, if you want toggleable or dynamic subsections that appear or disappear within another section (with the touch of a switch, for example), you may find the subsection functionality to be quite useful.

![Demo of switches and recursive subsections](https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/switches.gif "Demo of switches and recursive subsections")

As with the standard, single-level basic implementation of `BGRecursiveTableViewDataSource`, the standard `BGRecursiveTableViewDataSourceSectionGroup` class (which implements the `UITableViewDataSource` protocol and can be subclassed) is used for subsections.

Subsections allow you to **“pin” a `BGRecursiveTableViewDataSourceSectionGroup`** to an `NSIndexPath` in another `BGRecursiveTableViewDataSourceSectionGroup`, and insert or hide all rows dynamically at run-time with a single method call. Its initial state of being expanded or hidden is configurable.

### Usage

To set another `BGRecursiveTableViewDataSourceSectionGroup` to appear at an `NSIndexPath` **within another `BGRecursiveTableViewDataSourceSectionGroup`**, call this method **on the parent** (not the child):

```objc
- (void)setInnerSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)innerSectionGroup forRowAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isInitiallyActive:(BOOL)active;
```

**If your `UITableView` has NOT loaded its data yet,** that's all there is to it. 👍🏻 — If your `UITableView` **has** already loaded its data, or if you want to show/hide the contents of a subsection `BGRecursiveTableViewDataSourceSectionGroup` at any point later on, you can use this method:

```objc
- (void)insertOrRemoveRowsForInnerSectionGroupAtNonSubsectionIndexPath:(NSIndexPath *)indexPath isActive:(BOOL)active;
```

See the "Example" project for a demonstration.

## Core Data & `NSFetchedResultsController`

If you’re using Apple's [Core Data](https://en.wikipedia.org/wiki/Core_Data), you probably already know what you’re doing. Support for this is built-in using a provided subclass. Check out the "Example" project bundled with this pod/repo, and imagine subclassing and initializing **`BGRecursiveTableViewDataSourceFetchedResultsSectionGroup`** instead with a `NSFetchedResultsController` as a property. — More information on `NSFetchedResultsController` can be found here: https://developer.apple.com/reference/coredata/nsfetchedresultscontroller

`BGRecursiveTableViewDataSourceFetchedResultsSectionGroup` is a subclass of `BGRecursiveTableViewDataSourceSectionGroup` and not only inherits all of its parent's methods and properties, but also implements all of the standard section/row handling code for `NSFetchedResultsController`. Using it is easy:

```objc
- (instancetype)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
```

You can also replace the `NSFetchedResultsController` with another one (or `nil`) whenever you want:

```objc
- (void)replaceFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
```

Last, a subclassable convenience method is exposed for when objects are updated... allowing you to return `true` and avoid reloading cells versus just making manual changes to their content directly:

```objc
- (BOOL)updateCellAtIndexPathWithoutReloading:(NSIndexPath *)indexPath indexPathForFetchedResultControllerIfDifferent:(NSIndexPath *)newIndexPath becauseDidChangeObject:(id)anObject;
```

Implementation of this method **automatically avoids** calling `beginUpdates:` on the `UITableView` if `true` is returned, so scrolling behavior/performance is not affected by updates made directly to cells (by you).

### Using Core Data to generate empty sections

An additional subclass variant besides the standard one for using `NSFetchedResultsController` is also available: **`BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup`**

This subclass will instead create **empty sections** for each fetched object if subclassed to return `true` from its `displayEmptySectionsForFetchedResultsControllerObjects:` method. It does this based on the `NSFetchedResultsController` fetched results, but adds no rows. The fetched objects are still accessible from your code within the `BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup` itself, and you can instead choose to display other static or dynamic content in their place as you wish.

## Debugging Tips

Debugging exceptions and crashes with `UITableView` has always been kind of tedious since you can be somewhat in a void of information. `BGRecursiveTableViewDataSource` makes this a little easier, since you can toggle sections on/off or comment them out of your code entirely to see if issues persist. Likely, issues are in a much simpler format given the simplification and modularization of each `BGRecursiveTableViewDataSourceSectionGroup` implementation.

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
