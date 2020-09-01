@Library('commonLibrary') _

node('docker-builder-host-is') {
    try {

        stage ('Checkout') {
            deleteDir()
            checkout scm
        }

        stage ('Prepare config') {
            env.BRANCH_NAME=env.BRANCH_NAME.replaceAll("/", "-")
            sh "sed -i -e \'s/BRANCH/${BRANCH_NAME}/g\' gradle.properties" // replace branch in url placeholder
            def gradleProps = readProperties file: 'gradle.properties'
            conf = [
                'major': "${gradleProps['major']}"
                , 'minor': "${gradleProps['minor']}"
                , 'product' : "${gradleProps['projectName']}"
                , 'rancher-stack-name' : "${gradleProps['stackName']}"
                , 'dev-multi-branch-deployment' : "${gradleProps['devMultiBranchDeployment']}"
                , 'stage-multi-branch-deployment' : "${gradleProps['stageMultiBranchDeployment']}"
                , 'rancher-service-name' : "${gradleProps['serviceBaseName']}"
            ]
            configDocker(conf)
            printConfig(conf)
        }

        def projectName = conf['product']
        def release = conf['version']

        def builder = docker.image('tv2-is-docker-production.jfrog.io/gradle-builder-java-11:latest')

        committer = getCommitter()

        builder.pull()
        builder.inside("-e DOCKER_HOST=${env.DOCKER_HOST}") {

            withCredentials([usernamePassword(credentialsId: 'ci-arti-saas', usernameVariable: 'artifactory_user', passwordVariable: 'artifactory_password')]) {
                stage("Tests") {
                    sh "./gradlew -Partifactory_user='${artifactory_user}' -Partifactory_password='${artifactory_password}' clean test --no-build-cache"
                    publishHTML(target: [allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'build/reports/tests/test', reportFiles: 'index.html', reportName: 'Unit Test Result'])
                    publishHTML(target: [allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'build/reports/jacoco', reportFiles: 'index.html', reportName: 'Unit Test Coverage'])
                }
            }
            withCredentials([usernamePassword(credentialsId: 'ci-arti-saas', usernameVariable: 'artifactory_user', passwordVariable: 'artifactory_password')]) {
                stage("Gradle Build") {
                    sh "./gradlew -Partifactory_user='${artifactory_user}' -Partifactory_password='${artifactory_password}' clean build -x test"
                }
            }
        }

        stage('Docker Build') {
            if (conf['branch'] != 'master') {
                if (conf['dev-multi-branch-deployment']) {
                    sh "sed -i -e \'3s/${projectName}/${conf['rancher-service-name']}\\-${BRANCH_NAME}/g\' ${conf['rancher-docker-compose-dev']}"
                    sh "sed -i -e \'3s/${projectName}/${conf['rancher-service-name']}\\-${BRANCH_NAME}/g\' ${conf['rancher-compose-dev']}"
                }
                if (conf['stage-multi-branch-deployment']) {
                    sh "sed -i -e \'3s/${projectName}/${conf['rancher-service-name']}\\-${BRANCH_NAME}/g\' ${conf['rancher-docker-compose-stage']}"
                    sh "sed -i -e \'3s/${projectName}/${conf['rancher-service-name']}\\-${BRANCH_NAME}/g\' ${conf['rancher-compose-stage']}"
                }
            }
            buildDocker(conf)
        }

        stage ('Push docker artifact') {
            pushDockerArtifact(conf)
        }

        stage('deploy to dev') {
            deployToRancherDev(conf)
        }
        if (conf['branch'] == 'master' || conf['branch'].startsWith("release")) {
            stage('deploy to stage') {
                promoteDockerApproved(conf)
                deployToRancherStage(conf)
            }

            if (conf['branch'] == 'master') {
                stage('deploy to production') {
                    timeout(time: 15, unit: 'MINUTES') {
                        input 'Deploy to production?'
                    }
                    promoteDockerProduction(conf)
                    deployToRancherProduction(conf)
                }
            }
        }

    } catch (Exception e) {
    } finally {
        def builder = docker.image('tv2-is-docker-production.jfrog.io/gradle-builder-java-11:latest')
        builder.pull()
        builder.inside("-e DOCKER_HOST=${env.DOCKER_HOST}") {
            withCredentials([usernamePassword(credentialsId: 'ci-arti-saas', usernameVariable: 'artifactory_user', passwordVariable: 'artifactory_password')]) {
                stage('Check updates') {
                    sh "./gradlew -Partifactory_user='${artifactory_user}' -Partifactory_password='${artifactory_password}' checkUpdates"
                }

                stage("Analyze dependencies") {
                    sh "./gradlew -Partifactory_user='${artifactory_user}' -Partifactory_password='${artifactory_password}' dependencyCheckAnalyze"
                    publishHTML(target: [allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'build/reports', reportFiles: 'dependency-check-report.html', reportName: 'Dependency vulnerabilities'])
                }
            }
        }
    }
}
