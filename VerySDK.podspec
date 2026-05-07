Pod::Spec.new do |s|
  s.name             = 'VerySDK'
  s.version          = '1.0.39'
  s.summary          = 'Very SDK — palm biometric verification'
  s.description      = 'Palm biometric verification SDK for iOS.'
  s.homepage         = 'https://very.org'
  s.license          = { :type => 'Commercial', :file => 'LICENSE' }
  s.author           = { 'Very Mobile Inc.' => 'mail@very.org' }
  s.source           = { :git => 'https://github.com/veroslabs/very-sdk-ios.git', :tag => '1.0.39' }
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  s.default_subspecs = ['Bundled']

  s.subspec 'Core' do |core|
    core.vendored_frameworks = 'VerySDK.xcframework', 'PalmAPISaas.xcframework'
  end

  s.subspec 'Bundled' do |b|
    b.dependency 'VerySDK/Core'
    b.source_files    = 'BundledModel/*.swift'
    b.resource_bundle = { 'VerySDK_BundledModel' => ['BundledModel/packed_data.bin'] }
  end
end
