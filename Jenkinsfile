#!groovy

pipeline {
  agent none

  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('Build Docker image') {
      agent any
      steps {
        script {
          def dockerRepoName = 'zooniverse/zoo-stats-api-graphql'
          def dockerImageName = "${dockerRepoName}:${GIT_COMMIT}"

          def buildArgs = "--build-arg REVISION='${GIT_COMMIT}' ."
          def newImage = docker.build(dockerImageName, buildArgs)
          if (BRANCH_NAME == 'master') {
            newImage.push()
            newImage.push('latest')
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      when { branch 'master' }
      agent any
      steps {
        sh "kubectl --context azure apply --record -f kubernetes/"
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment.tmpl | kubectl --context azure apply --record -f -"
      }
    }
  }
  post {
    failure {
      script {
        if (BRANCH_NAME == 'master') {
          slackSend (
            color: '#FF0000',
            message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})",
            channel: "#ops"
          )
        }
      }
    }
  }
}
