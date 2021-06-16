# Moon Helm-Chart CI/CD 

Build & Deploy Moon Helm-Chart over EKS cluster using Jenkins CI/CD Pipeline   

##Requirements
| Name | Version |
|------|-------------|
| <a name="eksctl"></a> [eksctl](eksctl) | 0.40.0 
| <a name="AWS CLI"></a> [AWSCLI](AWSCLI) | v2 
| <a name="Helm"></a> [Helm](Helm) | v3.4.2 

## Clone repo
git clone https://github.com/ishais123/cat-facts-service.git

## EKS setup
```bash
// Use default aws profile by default, you can change it with --profile flag
// You can modify cluster configuration in eksctl.yaml file

eksctl create cluster -f deployment/eksctl.yaml 
aws eks  update-kubeconfig --name <cluster-name> --region <aws-region>
```
## Jenkins setup
```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update

kubectl create namespace jenkins
kubectl apply -f deployment/jenkins/jenkins-volume.yaml -n jenkins
kubectl apply -f deployment/jenkins/jenkins-sa.yaml -n jenkins
helm install jenkins -n jenkins -f values.yaml jenkins/jenkins
```
## Build locally
```bash
docker build -t ishais/cat-facts-service:local .
docker login -u=<docker hub username> -p=<docker hub password>
docker push  ishais/cat-facts-service:local
```
## Deploy locally
```bash
// You can customize the values.yaml file as you want

cd deployment/moon-chart
helm upgrade --install <release-name> .  -f values.yaml -n <namespace> --create-namespace
```
## Jenkins Pipeline
```bash
// Kubernetes plugin required

// You need to configure 2 Credentials: 
1) jenkins-user-github - github username & password
2) docker-hub-cred - docker-hub username & password

// In each pipelime you define you need to mark 2 checkbox under build trigger:
1) GitHub hook trigger for GITScm polling
2) Poll SCM

// You must configure repository setting in the pipeline configuration

// there is github webhook in repo which trigger the pipeline each push event
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
