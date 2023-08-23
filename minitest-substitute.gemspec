# frozen_string_literal: true

require_relative 'lib/minitest/substitute/version'

Gem::Specification.new do |spec|
  spec.name        = 'minitest-substitute'
  spec.version     = Minitest::Substitute::VERSION
  spec.summary     = 'Substitute values for the duration of a block or a group of tests'
  spec.description = <<~END
  END
  spec.authors     = ['Sven Schwyn']
  spec.email       = ['ruby@bitcetera.com']
  spec.homepage    = 'https://github.com/svoop/minitest-substitute'
  spec.license     = 'MIT'

  spec.metadata = {
    'homepage_uri'      => spec.homepage,
    'changelog_uri'     => 'https://github.com/svoop/minitest-substitute/blob/main/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/svoop/minitest-substitute',
    'documentation_uri' => 'https://www.rubydoc.info/gems/minitest-substitute',
    'bug_tracker_uri'   => 'https://github.com/svoop/minitest-substitute/issues'
  }

  spec.files         = Dir['lib/**/*']
  spec.require_paths = %w(lib)

  spec.cert_chain  = ["certs/svoop.pem"]
  spec.signing_key = File.expand_path(ENV['GEM_SIGNING_KEY']) if ENV['GEM_SIGNING_KEY']

  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']
  spec.rdoc_options    += [
    '--title', 'Minitest::Substitute',
    '--main', 'README.md',
    '--line-numbers',
    '--inline-source',
    '--quiet'
  ]

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_runtime_dependency 'minitest', '~> 5'

  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-flash'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'yard'
end
