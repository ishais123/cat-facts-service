podTemplate(containers: [
     containerTemplate(name: 'build', image: 'ishais/jenkins:v1', ttyEnabled: true, command: 'sleep 100000000000'),
     containerTemplate(name: 'deploy', image: 'dtzar/helm-kubectl', ttyEnabled: true, command: 'sleep 100000000000')
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
                IMAGE = "ishais/cat-facts-service"

                if ( GIT_TAG ){
                      //sh "docker build --network host -t ${IMAGE}:${GIT_TAG} ."
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "./build.sh ${IMAGE} ${GIT_TAG} ${USERNAME} ${PASSWORD}"
                        //sh "docker login -u='${USERNAME}' -p='${PASSWORD}'"
                        //sh "docker push ${IMAGE}:${GIT_TAG}"
                      }
                }
                else{
                      //sh "docker build --network host -t ${IMAGE}:latest ."
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                       sh "./build.sh ${IMAGE} latest ${USERNAME} ${PASSWORD}"
                       //sh "docker login -u='${USERNAME}' -p='${PASSWORD}'"
                       //sh "docker push ${IMAGE}:latest"
                      }
                }
            }
        }
        container('deploy') {
            stage('deploy') {
                sh "kubectl create ns moon"
                dir('deployment/moon-chart') {
                    sh "sed '0,/latest/s//$GIT_TAG/' values.yaml"
                    sh "helm upgrade --install moon-release . -f values.yaml -n moon"
                }
                sh "kubectl get svc -n moon"
            }
            //stage('destroy') {
              //  sh "kubectl delete ns moon"
            //}
        }
    }
  }