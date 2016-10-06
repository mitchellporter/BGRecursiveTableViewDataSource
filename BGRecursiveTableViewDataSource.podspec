Pod::Spec.new do |s|
s.name             = "BGRecursiveTableViewDataSource"
s.version          = "1.2.3"
s.homepage         = "https://github.com/benguild/BGRecursiveTableViewDataSource"
s.screenshots      = "https://raw.github.com/benguild/BGRecursiveTableViewDataSource/master/demo.png"
s.summary          = "Recursive “stacking” and modularization of `UITableViewDataSource(s)` with Apple iOS's `UIKit`."
s.license          = 'MIT'
s.author           = { "Ben Guild" => "email@benguild.com" }
s.source           = { :git => "https://github.com/benguild/BGRecursiveTableViewDataSource.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/benguild'

s.source_files     = 'BGRecursiveTableViewDataSource.{h,m}', 'BGRecursiveTableViewDataSourceSectionGroup.{h,m}', 'BGRecursiveTableViewDataSourceSectionGroup/BGRecursiveTableViewDataSourceFetchedResultsSectionGroup.{h,m}', 'BGRecursiveTableViewDataSourceSectionGroup/BGRecursiveTableViewDataSourceFetchedResultsSectionGroup/BGRecursiveTableViewDataSourceFetchedResultsEmptySectionGroup.{h,m}'
# s.private_header_files = 'Example/BGRecursiveTableViewDataSource_Tests/*.h' # NOTE: This is commented out because this file is not included above. However, it should be omitted in any case.

s.platform     = :ios, '8.0'
s.requires_arc = true

s.framework = 'UIKit'
s.framework = 'CoreData'

end
