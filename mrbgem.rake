MRuby::Gem::Specification.new('mruby-pong') do |spec|
  spec.license = 'MPL-2.0'
  spec.authors = 'Nazarii Sheremet'

  spec.add_dependency('mruby-json')
  spec.add_dependency('mruby-socket')
  spec.add_dependency('mruby-polarssl')
end