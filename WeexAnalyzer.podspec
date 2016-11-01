Pod::Spec.new do |s|
  s.name                = "WeexAnalyzer"
  s.version             = "0.0.1"
  s.summary             = "Weex Analyzer Bundle."
  s.description         = <<-DESC
                            Weex Analyzer Bundle for developers.
                         DESC
  s.homepage            = "https://github.com/xiayun200825/WeexAnalyzer"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
           Alibaba-INC copyright
    LICENSE
  }
  s.author              = { "xiayun" => "xiayun200825@163.com" }
  s.source              = { :git => "git@github.com:xiayun200825/WeexAnalyzer.git", :tag => '0.0.1' }
  s.requires_arc        = true
  s.platform            = :ios, "7.0"

  s.public_header_files = 'WeexAnalyzer/Sources/WeexAnalyzer.h','WeexAnalyzer/Sources/Menu/WXAMenuItem.h'
  s.source_files        = 'WeexAnalyzer/*.{c,h,m,S}','WeexAnalyzer/Source/**/*.{c,h,m,S}'

end