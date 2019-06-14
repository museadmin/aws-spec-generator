# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.1.0] - 03-12-2018
### Added
- Ability to run awspec generator
- Gemspec file updated to enable push to Rubygems.org

## [0.1.2] - 04-12-2018
### removed
- Removed test files as this is tested in aws-spec-etl

## [0.1.3] - 04-12-2018
### Changed 
- relative path of spechelper require statement

## [0.1.4] - 25-02-2019
### Changed
- debugging and tweaking for running in the cloud under an instance profile

## [0.1.5 - 0.1.13] - 26-02-2019
### Changed
- Exploratory debugging while trying to run in an AWS instance

## [0.2.0 - 0.2.6] 26-02-2019
- Remove stray system call in sg generate step
- Add clear down of output directory
- Fix for paths with spaces in them
- renamed generate_all method for consistency

## [0.2.7] 14-06-2019
- Fixed failing clear down of generated tests directory