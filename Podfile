# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Mission Connect' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  use_modular_headers!

  # Pods for Mission Connect
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'GoogleSignIn'
  pod 'AppAuth'
  pod 'SkyFloatingLabelTextField'
  pod 'RSSelectionMenu'
  pod 'Kingfisher', '~> 5.0'
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
  # https://firebase.google.com/docs/ios/setup#available-pods
end
