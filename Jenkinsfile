pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mado583/flask-app'  // Updated to include your Docker Hub username
        K8S_NAMESPACE = 'my-app'            // Kubernetes namespace
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
                    // Build the Docker image and tag it with the correct Docker Hub repo
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        // Log in to DockerHub and push the image
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                            docker.image("${DOCKER_IMAGE}").push('latest')  // Make sure to push with a tag like 'latest'
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: 'Kubernetes-Cluster', variable: 'K8S_SECRET')]) {
                    script {
                        // Save the Kubernetes config to a temporary location
                        writeFile(file: '/tmp/kubeconfig', text: K8S_SECRET)

                        // Set the KUBECONFIG environment variable to point to the temporary kubeconfig file
                        withEnv(["KUBECONFIG=/tmp/kubeconfig"]) {
                            // Apply Kubernetes Deployment YAML in the specified namespace
                            sh 'kubectl apply -f deployment.yaml --namespace=${K8S_NAMESPACE}'
                        }
                    }
                }
            }
        }
    }
}
