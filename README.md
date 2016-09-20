# BGRecursiveTableViewDataSource
Recursive “stacking” and modularization of `UITableViewDataSource(s)` with Apple iOS's `UIKit`

**Documentation and demo are a work in process,** but code is stable.

[![Version](https://img.shields.io/cocoapods/v/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![License](https://img.shields.io/cocoapods/l/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)
[![Platform](https://img.shields.io/cocoapods/p/BGRecursiveTableViewDataSource.svg?style=flat)](http://cocoapods.org/pods/BGRecursiveTableViewDataSource)

## Objective

Create a lightweight method of stacking and dynamically toggling existing, modular `UITableViewDataSource(s)` vertically for use with `UITableView` and `UITableViewController`, and making as few (if any) changes to them as possible.

## Implementation

**This module provides a liason between multiple stacked or "pinned" `UITableViewDataSource(s)` for use on a single `UITableView` or `UITableViewController`.** It also includes support for using `NSFetchedResultsController` with [Core Data](https://en.wikipedia.org/wiki/Core_Data) on a range of sections or subsections in a `UITableView`, rather than on the entire thing.

With this module, adding toggleable subsections using switches and reusing "blocks" of `UITableView` data throughout your app becomes much easier and more straightforward, while retaining familiarity through the use of a variant of the well-known `UIKit` protocol **`UITableViewDataSource`**.

![Imagine trying to maintain `UITableViewDataSource(s)` like this!](https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/demo.png "Imagine trying to maintain `UITableViewDataSource(s)` like this!")

> **`UITableViewDataSource(s)` for more complicated views (like the "Settings" app on iOS, for example) can be complex and difficult to maintain.** Making changes to an implementation of this using `BGRecursiveTableViewDataSource` are much more straightforward, in part thanks to modularization and code re-use.

This module allows you to build **modular, subclassable `UITableViewDataSource(s)` and group them together dynamically** for use with one or more `UITableViewController(s)` easily, WITHOUT the "spaghetti code" that requires dissection and complex testing during revision or bug-fixes.

## Support methods

Part of the simplicity of this implentation comes from the reuse of `UITableViewDataSource` for groups of `UITableView` sections or subsections. If code within your `BGRecursiveTableViewDataSourceSectionGroup` (implementing `UITableViewDataSource`) needs to resolve its top-level `NSIndexPath` from its internal, offset `NSIndexPath`, this can be accomplished by calling this method on the data-source itself:

```objc
- (NSIndexPath *)translateInternalIndexPathToTopLevel:(NSIndexPath *)indexPath forTopLevelSectionGroup:(BGRecursiveTableViewDataSourceSectionGroup *)sectionGroup;
```

Convenience methods for inserting, reloading, or deleting rows and sections dynamically (and also beginning/ending updates on the data-sources themselves) are provided simply by calling said methods on the data-sources rather than on the `UITableView` directly:

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

This also works for subsections as it would on top-level sections, hence the "recursive" description of the module. **For other useful methods,** see the header files of each of the bundled classes.

## Introducing Toggleable, Recursive “Subsections”

The simplest application of `BGRecursiveTableViewDataSource` is without any recursion or "subsections". However, if you want toggleable or dynamic subsections that appear or disappear within another section (with the touch of a switch, for example), you may find the subsection functionality to be quite useful.

As with the standard, single-level basic implementation of `BGRecursiveTableViewDataSource`, the standard `BGRecursiveTableViewDataSourceSectionGroup` class (which implements the `UITableViewDataSource` protocol and can be subclassed) is used for subsections.

Subsections allow you to **“pin” a `BGRecursiveTableViewDataSourceSectionGroup`** to an `NSIndexPath` in another section or subsection, and insert or hide all rows dynamically at run-time. Its initial state of being expanded or hidden is configurable.

You can recursively resolve (from the top-level) which subsection an `NSIndexPath` belongs to by calling a method on the `BGRecursiveTableViewDataSource`:

```objc
- (id)resolveSectionGroupAndInnerIndexPathForTopLevelIndexPath:(NSIndexPath *)indexPath matchBlock:(id (^)(BGRecursiveTableViewDataSourceSectionGroup *sectionGroup, NSIndexPath *innerIndexPath))matchBlock;
```

See the "Example" project for a demonstration.

## Core Data & `NSFetchedResultsController`

If you’re using Apple's [Core Data](https://en.wikipedia.org/wiki/Core_Data), you probably already know what you’re doing. Support for this is built-in using a provided subclass. Check out the “Example” project bundled with this pod/repo, and imagine subclassing and initializing **`BGRecursiveTableViewDataSourceFetchedResultsSectionGroup`** instead with a `NSFetchedResultsController` as a property.

There are some **additional methods available** for this subclass, so check out its header file.

### Using Core Data to generating empty sections

An additional subclass variant besides the standard one for using `NSFetchedResultsController` is also available: `BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup` — This subclass will create **empty sections** based on the `NSFetchedResultsController` content. You can fill these with static or other content as you wish.

## Debugging Tips

Debugging exceptions and crashes with `UITableView` has always been kind of exciting since you can be somewhat in void of information. `BGRecursiveTableViewDataSource` makes this a little easier, since you can toggle sections in more complicated instances or comment them out of your code entirely to see if issues persist.

It’s also possible to write more straightforward tests of your subclasses of modularized `BGRecursiveTableViewDataSourceSectionGroup` instances, versus trying to test a more intricate `UITableView`.

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
