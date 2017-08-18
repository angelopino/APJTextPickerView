Pod::Spec.new do |s|
  s.name             = 'APJTextPickerView'
  s.version          = '0.0.4'
  s.summary          = 'APJTextPickerView is simple implementation for UITextField to use as UIPickerView and UIDatePicker.'
  s.description      = <<-DESC
APJTextPickerView is simple implementation for UITextField to use as UIPickerView and UIDatePicker. It allows to use UITextField as UIPickerView or UIDatePicker to pick data easily. It is designed to present a picker view to select data in UITextField.
                       DESC

  s.homepage         = 'https://github.com/angelopino/APJTextPickerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Angelo Pino' => 'pino.angelo@gmail.com' }
  s.source           = { :git => 'https://github.com/angelopino/APJTextPickerView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'APJTextPickerView/Classes/**/*'
end
