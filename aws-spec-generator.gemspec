# frozen_string_literal: true

lib = File.expand_path(__dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lib/aws/spec/generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws-spec-generator'
  spec.version       = Aws::Spec::Generator::VERSION
  spec.authors       = ['Bradley Atkins']
  spec.email         = ['Bradley.Atkins@bjss.com']

  spec.summary       = 'Wrapper for awspec generate'
  spec.description   = 'Wrapper for awspec generate'
  spec.homepage      = 'https://github.com/museadmin/aws-spec-generator'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host'to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/museadmin/aws-spec-generator'
    spec.metadata['changelog_uri'] = 'https://github.com/museadmin/aws-spec-generator/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'aws_su', '>= 0.1.6'
  spec.add_development_dependency 'awsecrets', '~> 1.14.0'
  spec.add_development_dependency 'awspec'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
