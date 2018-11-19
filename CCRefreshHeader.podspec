

Pod::Spec.new do |s|

  s.name         = "CCRefreshHeader"
  s.version      = "1.0.0"
  s.homepage     = "https://github.com/demoncraz/CCRefreshHeader"
  s.license      = "MIT"
  s.summary      = "An easy-to-use refreshing header for UIScrollView"
  s.author             = { "chenc" => "cchen0907@gmail.com" }

  s.source       = { :git => "https://github.com/demoncraz/CCRefreshHeader.git", :tag => "#{s.version}" }

  s.source_files  = "CCRefreshHeader/*.{h,m}"

  s.ios.deployment_target = '10.0'

end
