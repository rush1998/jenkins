pipeline {
    agent any
    stages {
        stage('Ckeckout from GIt') {
            steps {
                git branch: 'main' , url: 'https://github.com/rush1998/jenkins.git'
            }
        }
        stage('Terraform Version') {
            steps {
                script{
                    sh 'terraform version'
                }
            }
        }
    }
}