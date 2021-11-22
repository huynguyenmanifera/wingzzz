# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.9.0] - 2020-12-02

### Added
- ZD#9595 Add extra locale fallback using "Accept-Language" HTTP header
- Appsignal for errortracking (replaces exception_notifier)

### Changed
- Update changelog format
- Several setup improvements (env-template/fix gem warnings)

## [1.8.0] - 2020-10-15

### Changed
- [send email after trail ends to user (14 days after trail starts)](https://www.pivotaltracker.com/story/show/174901069)
- [Send email 3 days after trail ends to user](https://www.pivotaltracker.com/story/show/174901068)

### Fixed
- [[ERROR app.mywingzzz.com] confirmations show (ActiveRecord::NotNullViolation)](https://www.pivotaltracker.com/story/show/175241253)

## [1.7.0]

### Changed
- Remove monthly payment reminder emails (https://www.pivotaltracker.com/story/show/174875626)

## [1.6.1]

### Changed
- Small HU translation change in `sign_up_success_text`

## [1.6.0]

### Changed
- Trial no longer requires payment up front (https://www.pivotaltracker.com/story/show/174858041)

### Fixed
- Link to marketing contact page (https://www.pivotaltracker.com/story/show/175051522)

## [1.5.0]

### Added
- Add Google Tag Manager (https://www.pivotaltracker.com/story/show/173809800)

## [1.4.1]

### Fixed
- Welcome email is always English, regardless of language that was used for sign up (https://www.pivotaltracker.com/story/show/173846978)
- Signup flow cannot be completed if payment is not completed immediately (https://www.pivotaltracker.com/story/show/173918675)
