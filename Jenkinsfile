pipeline { 
    agent { label 'slave-1'}
    
    tools {
        maven 'maven3'
    }

    stages {
        
        
        stage('build') {
            steps {
               sh "mvn package"
            }
        }
    }
}
