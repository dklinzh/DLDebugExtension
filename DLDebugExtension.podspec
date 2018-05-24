Pod::Spec.new do |s|
  s.name             = 'DLDebugExtension'
  s.version          = '0.1.0'
  s.summary          = 'Debug tools and extension frameworks for iOS development.'

  s.description      = <<-DESC
                        Debug tools and extension frameworks for iOS development.
                       DESC

  s.homepage         = 'https://github.com/dklinzh/DLDebugExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dklinzh' => 'linzhdk@gmail.com' }
  s.source           = { :git => 'https://github.com/dklinzh/DLDebugExtension.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  
  s.subspec 'Log' do |log|
    log.private_header_files = 'DLDebugExtension/Classes/Log/_*.h'
    log.source_files = 'DLDebugExtension/Classes/Log/*'
  end

end
