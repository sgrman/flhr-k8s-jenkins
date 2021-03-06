# your server name goes here
server=https://k8s1.flhrnet.local:8443
# the name of the secret containing the service account token goes here
name=jenkins-token-6979r
ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' | base64 -D)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' | base64 -D)
echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > sa.kubeconfig
