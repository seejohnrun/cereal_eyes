require File.dirname(__FILE__) + '/lib/cereal_eyes/version'

spec = Gem::Specification.new do |s|
  s.name = 'cereal_eyes'
  s.author = 'John Crepezzi'
  s.add_development_dependency('rspec')
  s.description = 'a proof of concept serialization format based on GSON'
  s.email = 'john.crepezzi@gmail.com'
  s.files = Dir['lib/**/*.rb']
  s.homepage = 'http://seejohnrun.github.com/cereal_eyes'
  s.require_paths = ['lib']
  s.summary = 'GSON-like Serialization'
  s.test_files = Dir.glob('spec/*.rb')
  s.version = CerealEyes::VERSION
end
