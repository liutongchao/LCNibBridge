
Pod::Spec.new do |s|

  s.name         = 'LCNibBridge'
  s.version      = '1.3.3'
  s.summary      = "A Swift IB tool used on iOS ."

  s.description  = <<-DESC
		   It is a Swift IB tool used on iOS . which implement by Swift
                   DESC

  s.homepage     = "https://github.com/liutongchao/LCNibBridge"
  s.license      = 'MIT'
  s.author             = { 'liutongchao' => '413281269@qq.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/liutongchao/LCNibBridge.git", :tag => "1.3.3" }

  s.source_files  = 'Source/*.swift'
  s.frameworks = "Foundation", "UIKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

end
