Pod::Spec.new do |s|
  s.name             = 'DLDebugExtension'
  s.version          = '0.2.1'
  s.summary          = 'Debug tools and extension frameworks for iOS development.'

  s.description      = <<-DESC
                        Debug tools and extension frameworks for iOS development.
                       DESC

  s.homepage         = 'https://github.com/dklinzh/DLDebugExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dklinzh' => 'linzhdk@gmail.com' }
  s.source           = { :git => 'https://github.com/dklinzh/DLDebugExtension.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  
  s.subspec 'Log' do |ss|
    ss.private_header_files = 'DLDebugExtension/Classes/Log/_*.h'
    ss.source_files = 'DLDebugExtension/Classes/Log/*'
  end

  s.subspec 'Diagnose' do |ss|
    ss.private_header_files = 'DLDebugExtension/Classes/Diagnose/_*.h'
    ss.source_files = 'DLDebugExtension/Classes/Diagnose/*'
  end

  s.subspec 'Config' do |ss|
    ss.private_header_files = 'DLDebugExtension/Classes/Config/_*.h'
    ss.source_files = 'DLDebugExtension/Classes/Config/*'
  end

  s.subspec 'Debug' do |ss|
    ss.dependency 'CocoaDebug', '~> 1.0'
    ss.dependency 'FLEX', '~> 3.0'
    ss.private_header_files = 'DLDebugExtension/Classes/Debug/_*.h'
    ss.source_files = 'DLDebugExtension/Classes/Debug/*'
  end

end
