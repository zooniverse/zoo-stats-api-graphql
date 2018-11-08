#!groovy

node {
    checkout scm

    def dockerRepoName = 'zooniverse/zoo-event-stats-postgres'
    def dockerImageName = "${dockerRepoName}:${BRANCH_NAME}"
    def newImage = null

    stage('Build Docker image') {
        newImage = docker.build(dockerImageName)
        newImage.push()
    }
}