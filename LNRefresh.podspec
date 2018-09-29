Pod::Spec.new do |s|
  s.name         = "LNRefresh"
  s.version      = "1.0.4"
  s.summary      = "LNRefresh component"
  s.description  = <<-DESC
  LNTheme is a framework to integrate night mode to application written in OC.
                   DESC
  s.homepage     = "https://github.com/wedxz/LNRefresh"
  s.license      = { :type => "GPLV3", :file => "LICENSE" }
  s.author             = { "wedxz" => "wedxzl@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/wedxz/LNRefresh.git", :tag => s.version }
  s.source_files = "LNRefresh/LNRefresh/*.{h,m}"
  s.exclude_files= "LNRefresh/*.plist"
  s.resources    = "LNRefresh.bundle"
  s.requires_arc = true
end
