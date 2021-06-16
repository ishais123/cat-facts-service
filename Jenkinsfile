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
                IMAGE = "ishais/cat-facts-service"

                GIT_TAG = sh(returnStdout: true, script: "git tag --contains | head -1").trim()
                LATEST_TAG = "latest"

                if ( GIT_TAG ){
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "./build.sh ${IMAGE} ${GIT_TAG} ${USERNAME} ${PASSWORD}"
                      }
                }
                else{
                      withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                       sh "./build.sh ${IMAGE} ${LATEST_TAG} ${USERNAME} ${PASSWORD}"
                      }
                }
            }
        }
        container('deploy') {
            stage('deploy') {
                sh "kubectl create ns moon"
                dir('deployment/moon-chart') {
                    sh "helm upgrade --install moon-release .  -f values.yaml --set facts.tag=${GIT_TAG} -n moon"
                }
                sh "kubectl get svc -n moon"
            }
            //stage('destroy') {
              //  sh "kubectl delete ns moon"
            //}
        }
    }
  }
