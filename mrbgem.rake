MRuby::Gem::Specification.new('mruby-pong') do |spec|
  spec.license = 'MPL-2.0'
  spec.authors = 'Nazarii Sheremet'

  spec.add_dependency('mruby-sprintf', :core => 'mruby-sprintf')
  spec.add_dependency('mruby-socket')
  spec.add_dependency('mruby-polarssl')
  spec.add_dependency('mruby-thread', :github => 'nsheremet/mruby-c11thread', :branch => 'c11thread')
  spec.add_dependency('mruby-regexp-pcre', :github => 'nsheremet/mruby-regexp-pcre')
  spec.add_dependency('mruby-json', :github => 'mattn/mruby-json')
end