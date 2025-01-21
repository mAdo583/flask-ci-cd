pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'flask-app'  // Name of the Docker image
        K8S_NAMESPACE = 'my-app'    // Kubernetes namespace
    }
    
    stages {
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_PASS')]) {
                    git credentialsId: 'github-credentials', url: 'https://github.com/mAdo583/flask-ci-cd.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                            docker.image("${DOCKER_IMAGE}").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes Deployment YAML in the specified namespace
                    sh 'kubectl apply -f k8s/deployment.yaml --namespace=${K8S_NAMESPACE}'
                }
            }
        }
    }
}
