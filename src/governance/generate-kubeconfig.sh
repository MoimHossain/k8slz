workloadName='mesos'
apiServer=$(kubectl config view -o jsonpath='{.clusters[*].cluster.server}')
serviceAccount=$(kubectl get serviceaccounts -n $workloadName | grep $workloadName | cut -d' ' -f1)
secretName=$(kubectl get secrets -n $workloadName | grep $workloadName | cut -d' ' -f1)

ca=$(kubectl get secret/$secretName -n $workloadName -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$secretName -n $workloadName -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$secretName -n $workloadName -o jsonpath='{.data.namespace}' | base64 --decode)

echo "workloadName: $workloadName"
echo "apiServer: $apiServer"
echo "namespace: $namespace"
echo "serviceAccount: $serviceAccount"
echo "secretName: $secretName"
echo "ca: $ca"
echo "token: $token"

echo "
apiVersion: v1
kind: Config
clusters:
- name: ${workloadName}-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${apiServer}
contexts:
- name: ${workloadName}-context
  context:
    cluster: ${workloadName}-cluster
    namespace: ${namespace}
    user: ${serviceAccount}
current-context: ${workloadName}-context
users:
- name: ${serviceAccount}
  user:
    token: ${token}
" > sa.kubeconfig