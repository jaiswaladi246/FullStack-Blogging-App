pipeline{
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner' // we have to configure sonar scanner to manage jenkins 
    }
    //squ_7b041cd290ddd07b4f0c560ff11bf4fff1ca64fd
    
    stages{
        stage("Hello"){
            steps{
                echo "Hello World"
            }  
        }
        stage("Git Checkout"){
            steps{
                echo "Git Checkout"
                git branch: 'main', url: 'https://github.com/mihirmodi2561/FullStack-Blogging-App.git'
            }  
        }
        stage("Compile"){
            steps{
                sh "mvn compile"
            }  
        }
        stage("Test"){
            steps{
                sh "mvn test"
            }  
        }
        stage("Trivy"){
            steps{
                sh "trivy fs --format table -o fs.html ."
                // trivy file system format in table form -o(which file we create )
            }  
        }
        stage("SonarQube Analysis"){
            steps{
                // SonarQube token configure so we can connect to jenkins.
                // Add credinatials 
                // This stage will do analysis of code and show to jenkins server
                // Pipeline syntax Check video at 54:00
                withSonarQubeEnv('sonar-server') {
                sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-app -Dsonar.projectKey=Blogging-app \
                        -Dsonar.java.binaries=target'''
                }
            }  
        }
            // Check 57:10 to
            // maven releast and snapshot
            // Go to Manage file Jenkins
        stage("Maven Build"){
            steps{
                sh "mvn package"
            }  
        }
        stage("Publish Artifacts"){
            steps{
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                sh "mvn deploy"
                }
            }  
        }

        stage("Docker Build & Tag"){
            steps{
                script{
                withDockerRegistry(credentialsId: 'docker-pass', toolName: 'docker') {
                sh "docker build -t mihirmodi2561/bloggingapp:latest ."
                }
                }
            }  
        }
        
        stage("Trivy image check"){
            steps{
                sh "trivy image --format table -o image.html mihirmodi2561/bloggingapp:latest"
                // trivy file system format in table form -o(which file we create )
            }  
        }
        
        stage("Docker Push Image"){
            steps{
                script {
                withDockerRegistry(credentialsId: 'docker-pass', toolName: 'docker') {
                sh "docker push mihirmodi2561/bloggingapp:latest"
                }
            }  
        }
    }
        stage("k8s Deploy"){
            steps{
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://7EE268756CE506B900F52BD6BE9B45F1.gr7.us-east-1.eks.amazonaws.com') {
                sh "kubectl apply -f deployment-service.yml"
                sleep 20
            }
            }
        }
        
        stage("Verify Deploy"){
            steps{
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://7EE268756CE506B900F52BD6BE9B45F1.gr7.us-east-1.eks.amazonaws.com') {
                sh "kubectl get pods"
                sh "kubectl get svc"
            }
            }
        }
    }
}