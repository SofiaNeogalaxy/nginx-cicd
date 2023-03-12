pipeline {
    agent any
    parameters {
        choice(
            name: 'Terraform_Action',
            choices: "apply\ndestroy",
            description: 'Create or destroy the infrastructure'
        )

        choice(
            name: 'Environment',
            choices: "staging\nproduction",
            description: 'Environment to setup the infrastructure'
        )
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'jenkins_pk', url: 'git@github.com:0xsudo/nginx-devops-project.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    if (params.Terraform_Action == "apply") {
                        sh 'docker build -f nginx/Dockerfile -t kaokakelvin/nginx-image:latest -t kaokakelvin/nginx-image:""$BUILD_NUMBER"" --no-cache .'
                    }
                }
            }
        }

        stage('Docker Publish') {
            steps {
                script {
                    if (params.Terraform_Action == "apply") {
                        withDockerRegistry([credentialsId: "devopsrole-dockerhub", url: ""]) {
                        sh 'docker push kaokakelvin/nginx-image:""$BUILD_NUMBER""'
                        sh 'docker push kaokakelvin/nginx-image:latest'
                        }
                    }
                }
            }
        }

        stage('Terraform') {
            steps {
                script {
                    if (params.Terraform_Action == "apply" && params.Environment == "staging") {
                        sh 'terraform -chdir=./terraform/static-web init'
                        sh 'terraform -chdir=./terraform/static-web apply --auto-approve'
                    }
                    if (params.Terraform_Action == "apply" && params.Environment == "production") {
                        retry(count: 3) {
                            sh 'terraform -chdir=./terraform/k8s init'
                            sh 'terraform -chdir=./terraform/k8s apply --auto-approve'
                        }
                    }
                    if (params.Terraform_Action == "destroy" && params.Environment == "staging") {
                        sh 'terraform -chdir=./terraform/static-web destroy --auto-approve'
                    }
                    if (params.Terraform_Action == "destroy" && params.Environment == "production") {
                        sh 'terraform -chdir=./terraform/k8s destroy --auto-approve'
                    }
                }
            }
        }

        stage('Environment Setup') {
            steps {
                script {
                    if (params.Terraform_Action == "apply" && params.Environment == "staging") {
                        sh './envt_setup.sh'
                    }
                }
            }
        }

        stage('Ansible'){
            steps {
                script {
                    if (params.Terraform_Action == "apply" && params.Environment == "staging") {
                        retry(count: 5) {
                            // sh 'ansible-playbook -i ansible/inventory-aws_ec2.yaml -i ansible/all_servers_aws_ec2 ansible/ec2-playbook -vvv'
                            ansiblePlaybook installation: 'ansible', playbook: 'ansible/ec2-playbook', inventory: 'ansible/all_servers_aws_ec2', extras: '--inventory ansible/inventory-aws_ec2.yaml -vvv'
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }

}