projectId = "wingzzz"
support.initializeCache(projectId)

pipeline {
  agent {
    dockerfile {
      filename "dockerfiles/ci/Dockerfile"
      additionalBuildArgs "${support.ciDockerFileBuildArgs()} --pull"
      args "${support.ciDockerFileRunArgs(projectId)} -u root"
    }
  }

  options {
    ansiColor("xterm")
  }

  environment {
    RAILS_ENV = "test"
    CUKES_HEADLESS = "true"
    DATABASE_URL = "postgres://postgres:postgres@localhost/wingzzz_test"
    RAILS_MASTER_KEY = credentials("RAILS_MASTER_KEY")
    AWS_ACCESS_KEY_ID = credentials("AWS_ACCESS_KEY_ID")
    AWS_SECRET_ACCESS_KEY = credentials("AWS_SECRET_ACCESS_KEY")
    KITCHEN_SINK = "true"
  }

  stages {
    stage("Setup") {
      steps {
        sh "bundle config --global jobs \$(cat /proc/cpuinfo | grep -c processor)"
        sh "service postgresql start"

        sh "bundle install"
        sh "rm -rf node_modules && mv /tmp/yarn/node_modules node_modules"

        // workaround Webpacker sometimes not recompiling due to state in tmp/cache/webpacker :-(
        sh "rm -rf ./tmp"

        sh "bin/rails db:setup"
      }
    }

    stage("Tests") {
      steps {
        sh "bin/rake ci"
      }
    }
  }

  post {
    changed {
      script { support.slackNotification(channel: "#wingzzz") }
    }

    always {
      script {
        support.restoreWorkspacePermissions()
      }
    }
  }
}
