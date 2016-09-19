# BGRecursiveTableViewDataSource
Recursive “stacking” and modularizing of `UITableViewDataSource(s)`

## Overview

`UITableViewDataSource(s)` for more complicated views (consider **the "Settings" app on iOS**, for example) can be complex and difficult to maintain. Displaying multiple sections with varying content that is perhaps dynamic often without "spaghetti code" is essential.

One strategy for managing varying sections of content that are both static and dynamic is by using `BGRecursiveTableViewDataSource`. This library allows you to build **modular, subclassable `UITableViewDataSource(s)` and group them together dynamically** for use with `UITableViewController(s)` easily.

It also includes native support for **`NSFetchedResultsController`** via an optional subclass.

## Introducing Toggleable, Recursive “Subsections”

The simplest application of `BGRecursiveTableViewDataSource` is without any recursion or "subsections". However, if you want toggleable or dynamic subsections that appear or disappear with the touch of a switch (for example), you may find the subsection functionality to be useful.

Subsections allow you to **“pin” a `BGRecursiveTableViewDataSourceSectionGroup`** (`UITableViewDataSource` subclass) to an `NSIndexPath` within another `BGRecursiveTableViewDataSourceSectionGroup`, recursively. You may have it appear/disappear with a method call at any level in your top-level `BGRecursiveTableViewDataSource`, and its initial state of being expanded or hidden is configurable.

------------------------------------------------------------------

*More to come...*
