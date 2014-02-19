# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spbtv_database/version'

Gem::Specification.new do |spec|
  spec.name          = "spbtv_database"
  spec.version       = Database::VERSION
  spec.authors       = ["facetostool"]
  spec.email         = ["ivan.tugin@gmail.com"]
  spec.description   = %q{SPB TV test}
  spec.summary       = %q{Simple database with some test}
  spec.homepage      = "https://github.com/facetostool/spbtv"
  spec.license       = "MIT"

  spec.files         = ["lib/spbtv_database.rb", "lib/spbtv_database/request.rb", "lib/spbtv_database/table.rb",
                        "lib/spbtv_database/table_initializer.rb", "lib/spbtv_database/version.rb",
                        "lib/spbtv_database/table_configuration.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
