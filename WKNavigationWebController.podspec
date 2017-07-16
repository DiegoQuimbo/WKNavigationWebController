#
# Be sure to run `pod lib lint WKNavigationWebController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WKNavigationWebController'
  s.version          = '0.1.1'
  s.summary          = 'WKWebView with navigation and login'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This CocoaPod provides the ability to use a WKWebView with navigation and login'

  s.homepage         = 'https://github.com/DiegoQuimbo/WKNavigationWebController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DiegoQuimbo' => 'dquimbo22@gmail.com' }
  s.source           = { :git => 'https://github.com/DiegoQuimbo/WKNavigationWebController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WKNavigationWebController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WKNavigationWebController' => ['WKNavigationWebController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
