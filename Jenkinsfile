podTemplate(containers: [
     containerTemplate(name: 'deploy', image: 'dtzar/helm-kubectl', ttyEnabled: true, command: 'sleep 100000000000'),
     containerTemplate(name: 'build', image: 'docker', ttyEnabled: true, command: 'sleep 100000000000')
  ],
  volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')] )
  {
    node(POD_LABEL) {
        git branch: 'main',
        credentialsId: 'jenkins-user-github',
        url: 'https://github.com/ishais123/cat-facts-service.git'
        container('build') {
            stage('build') {
                GIT_TAG = sh(returnStdout: true, script: "git tag --contains | head -1").trim()

                if ( GIT_TAG ){
                      sh "docker build --network host -t ishais/cat-facts-service:${GIT_TAG} ."
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u='${USERNAME}' -p='${PASSWORD}'"
                        sh "docker push ishais/cat-facts-service:${GIT_TAG}"
                      }
                }
                else{
                      sh "docker build --network host -t ishais/cat-facts-service:latest ."
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                       sh "docker login -u='${USERNAME}' -p='${PASSWORD}'"
                       sh "docker push ishais/cat-facts-service:latest"
                      }
                }
                sh "docker images"
            }
        }
        container('deploy') {
            stage('deploy') {
                sh "kubectl create ns moon"
                dir('deployment/moon-chart') {
                    sh "sed -i 's/latest/$GIT_TAG/g' values.yaml"
                    sh "helm upgrade moon-release . -f values.yaml -n moon"
                }
                sh "kubectl get svc -n moon"
            }
            //stage('destroy') {
              //  sh "kubectl delete ns moon"
            //}
        }
    }
  }