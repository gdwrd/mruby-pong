MRuby::Gem::Specification.new('mruby-pong') do |spec|
  spec.license = 'MPL-2.0'
  spec.authors = 'Nazarii Sheremet'

  spec.add_dependency('mruby-sprintf', :core => 'mruby-sprintf')
  spec.add_dependency('mruby-socket')
  spec.add_dependency('mruby-polarssl')
  spec.add_dependency('mruby-thread')
  spec.add_dependency('mruby-json', :github => 'mattn/mruby-json')
  spec.add_dependency('mruby-catch-throw', :github => 'IceDragon200/mruby-catch-throw')
  spec.add_dependency('mruby-hash-ext', core: 'mruby-hash-ext')

  add_test_dependency 'mruby-simpletest'
end
