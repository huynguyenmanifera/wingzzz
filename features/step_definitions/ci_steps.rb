Given('not on CI') { pending if ENV['CI'] || ENV['JENKINS_URL'] }
