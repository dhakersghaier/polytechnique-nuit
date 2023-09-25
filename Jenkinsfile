pipeline {
    agent any

    tools {
        nodejs 'node-20'
        ansible 'Ansible'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-ID')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        DOCKER_IMAGE_TAG = ""
        CURRENT_STAGE = ''
        NAME = "dhakersg/vue-js-app"
        VERSION = "${env.BUILD_ID}"
        SONAR_TOKEN = credentials('sonar-cube-token')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    CURRENT_STAGE = 'Build'
                    try {
                        sh "docker build -t ${NAME} ."
                        sh "docker tag ${NAME}:latest ${NAME}:${VERSION}"
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Build failed: ${e.message}")
                    }
                }
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    CURRENT_STAGE = 'Code Analysis'
                    def scannerHome = tool 'sonar-scanner'
                    try {
                        withSonarQubeEnv('sonar-scanner') {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.login=${SONAR_TOKEN}"
                        }
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Code Analysis failed: ${e.message}")
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    CURRENT_STAGE = 'Push to Docker Hub'
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                            sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                            sh "docker push dhakersg/vue-js-app:latest"
                        }
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Push to Docker Hub failed: ${e.message}")
                    }
                }
            }
        }

        // stage('Terraform & Ansible Deployment') {
        //     steps {
        //         script {
        //             CURRENT_STAGE = 'Terraform & Ansible Deployment'
        //             try {
        //                 sh "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
        //                 sh "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
        //                 sh "cd terraform && terraform init"
        //                 // sh "cd terraform && terraform destroy -auto-approve"
        //                 sh "cd terraform && terraform plan"
        //                 sh "cd terraform && terraform apply -auto-approve"
        //                 sh "cd terraform && bash -x ./terraform_inventory.sh"
        //                 sh "cd terraform && cat inventory.ini"
        //                 sh "cd terraform && ansible-playbook -i inventory.ini ansible-playbook.yml -e \"ansible_ssh_common_args='-o StrictHostKeyChecking=no'\""

        //             } catch (Exception e) {
        //                 currentBuild.result = 'FAILURE'
        //                 error("Terraform Deployment failed: ${e.message}")
        //             }
        //         }
        //     }
        // }
    }

    post {
        failure {
            script {
                def failedStageName = CURRENT_STAGE ?: "Unknown"
                emailext subject: "Pipeline Failed in Stage: ${currentBuild.fullDisplayName}",
                          body: "The pipeline '${currentBuild.fullDisplayName}' has failed in the '${failedStageName}' stage. Please investigate the issue.",
                          to: "dhakersg@gmail.com",
                          mimeType: 'text/html'
            }
        }
    }
}