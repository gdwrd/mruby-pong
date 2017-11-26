MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem '../mruby-pong'
  conf.gem :github => 'matsumotory/mruby-simpletest'
end