Pod::Spec.new do |spec|
  spec.name         = 'TCCCCallKit-Swift'
  spec.version      = '1.0.0'
  spec.platform     = :ios
  spec.ios.deployment_target = '10.0'
  spec.license      = { :type => 'Proprietary',
    :text => <<-LICENSE
    copyright 2017 tencent Ltd. All rights reserved.
    LICENSE
  }
  spec.homepage     = 'https://cloud.tencent.com/product/ccc'
  spec.documentation_url = 'https://cloud.tencent.com/product/ccc'
  spec.authors      = 'Tencent Cloud Contact Center'
  spec.summary      = 'TCCCCallKit'
  spec.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
  
  spec.dependency 'SnapKit'
  spec.dependency 'SDWebImage'

  spec.requires_arc = true
  spec.static_framework = true
  spec.source = { :path => './' }
  spec.swift_version = '5.0'
  
  spec.ios.framework = ['AVFoundation', 'Accelerate', 'AssetsLibrary']
  spec.library = 'c++', 'resolv', 'sqlite3'

  spec.default_subspec = 'TCCC'

  spec.pod_target_xcconfig = {'SWIFT_INSTALL_OBJC_HEADER' => 'NO'}

  spec.subspec 'TCCC' do |tccc|
    tccc.source_files = 'TCCCCallKit-Swift/**/*.{h,m,mm,swift}'
    tccc.resource_bundles = {
      'TCCCCallKitBundle' => ['TCCCCallKit-Swift/Resources/*.gif', 'TCCCCallKit-Swift/Resources/**/*.strings', 'TCCCCallKit-Swift/Resources/AudioFile', 'TCCCCallKit-Swift/Resources/*.xcassets']
    }
    tccc.resource = ['TCCCCallKit-Swift/Resources/*.bundle']
    tccc.vendored_frameworks = ['Frameworks/TCCCSDK.framework','Frameworks/TXFFmpeg.xcframework','Frameworks/TXSoundTouch.xcframework']
  end
  
end

