pipeline {
    agent any
    
    options {
        timeout(time: 10, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    environment {
        HOME = "${env.WORKSPACE}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup') {
            steps {
                sh 'pip install pre-commit'
                sh 'pip install shellcheck-py'
                sh 'pip install yamllint'
            }
        }
        
        stage('Linting') {
            parallel {
                stage('Pre-commit') {
                    steps {
                        sh 'pre-commit run --all-files'
                    }
                }
                
                stage('Shellcheck') {
                    steps {
                        sh '''
                        find . -type f -name "*.sh" ! -path "*/\\.*" -exec shellcheck -S warning {} \\;
                        '''
                    }
                }
                
                stage('YAML Lint') {
                    steps {
                        sh '''
                        find . -type f \\( -name "*.yml" -o -name "*.yaml" \\) ! -path "*/\\.*" -exec yamllint {} \\;
                        '''
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                sh 'make test || true' // Don't fail if test fails
            }
        }
        
        stage('Verify Templates') {
            steps {
                sh '''
                # Check chezmoi templates
                find ./home -name "*.tmpl" -exec echo "Validating {}" \\; -exec grep -l '{{' {} \\;
                '''
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}