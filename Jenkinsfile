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
                // Stage Variables
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
                // Stage Variables
                NAMESPACE = 'moon'
                RELEASE = 'moon-release'
                VALUES_FILE = 'values.yaml'

                dir('deployment/moon-chart') {
                    sh "helm upgrade --install ${RELEASE} .  -f ${VALUES_FILE} --set facts.image.tag=${GIT_TAG} -n ${NAMESPACE} --create-namespace"
                }
                sh "kubectl get svc -n $NAMESPACE"
            }
            stage('test') {
                // Stage Variables
                NAMESPACE = 'moon'
                SVC_NAME = 'moon-release-cat-facts'
                SVC_HOSTNAME = sh(returnStdout: true, script: "kubectl get services -n ${NAMESPACE} ${SVC_NAME} --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'").trim()
                SVC_PORT = '8081'
                SVC_ROUTE = 'api/v1/cat/facts'

                //sh "sleep 200"
                CURL_TARGET = "${SVC_HOSTNAME}:${SVC_PORT}/${SVC_ROUTE}"

                sh "curl ${SVC_HOSTNAME}:${SVC_PORT}/${SVC_ROUTE}"
            }
        }
    }
  }

