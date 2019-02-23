target 'MP' do

  pod 'Alamofire'
  pod 'Gloss'
  pod 'KeychainSwift'
  pod 'Nuke'
  pod "CDAlertView"
  pod "SkeletonView"

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
