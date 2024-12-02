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
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terrafrom plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
         stage('Approve To Destroy') {
            steps {
                input message: 'Approve to Destroy', ok: 'Destroy'
            }
        }
        stage('Terraform Destroy') {
            steps {
                script {
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
}