pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/mAdo583/flask-ci-cd.git'
            }
        }
        stage('Build Flask App') {
            steps {
                script {
                    // Install dependencies
                    sh 'pip install -r requirements.txt'
                }
            }
        }
        stage('Test Flask App') {
            steps {
                script {
                    // Run tests if applicable
                    sh 'pytest tests/'
                }
            }
        }
        stage('Deploy Flask App') {
            steps {
                script {
                    // Deploy the app (e.g., to AWS, Heroku, or another server)
                    sh './deploy.sh'
                }
            }
        }
    }
}

