pipeline {
    agent { label 'agent1' }

    tools {
        git 'Default'
    }

    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    sh 'chmod +x ./gradlew'
                }
            }
        }
        stage('Parallel Checks') {
            parallel {
                stage('Checkstyle') {
                    stages {
                        stage('Checkstyle Main') {
                            steps {
                                script {
                                    sh './gradlew checkstyleMain'
                                }
                            }
                        }
                        stage('Checkstyle Test') {
                            steps {
                                script {
                                    sh './gradlew checkstyleTest'
                                }
                            }
                        }
                    }
                }

                stage('Compile') {
                    steps {
                        script {
                            sh './gradlew compileJava'
                        }
                    }
                }

                stage('Tests and Coverage') {
                    stages {
                        stage('Test') {
                            steps {
                                script {
                                    sh './gradlew test'
                                }
                            }
                        }
                        stage('JaCoCo Report') {
                            steps {
                                script {
                                    sh './gradlew jacocoTestReport'
                                }
                            }
                        }
                        stage('JaCoCo Verification') {
                            steps {
                                script {
                                    sh './gradlew jacocoTestCoverageVerification'
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Package') {
            steps {
                script {
                    sh './gradlew bootJar'
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t job4j_devops .'
                }
            }
        }
    }
}
