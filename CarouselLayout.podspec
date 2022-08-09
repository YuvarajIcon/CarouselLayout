#
# Be sure to run `pod lib lint CarouselLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CarouselLayout'
  s.version          = '0.1.2'
  s.summary          = 'A collection view layout that emulates a Carousel.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A UICompositional layout that emulates side scrolling carousel effect.'

  s.homepage         = 'https://github.com/YuvarajIcon/CarouselLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yuvaraj.australia@gmail.com' => 'YuvarajIcon' }
  s.source           = { :git => 'https://github.com/YuvarajIcon/CarouselLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_versions = '4.0'
  s.source_files = 'CarouselLayout/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CarouselLayout' => ['CarouselLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
