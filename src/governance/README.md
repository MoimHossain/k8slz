# GitHub action for workload team

Below is an example of a GitHub workflow for a workload team (i.e. mesos) who can leverage the secrets created by governance team to connect to a specific namespace for the project. 

```yaml
name: Deployment
# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:


jobs:  
  deploy:    
    runs-on: ubuntu-latest
    environment: Production # We are targetting the environment here    
    steps:      
      - uses: actions/checkout@v2      
      - name: Deploy workload
        run: |
          mkdir $HOME/.kube/
          echo "${{ secrets.K8S_TOKEN }}" | base64 -d > $HOME/.kube/config
          
          kubectl get all -n mesos
          kubectl get serviceaccounts -n mesos
          # kubectl get nodes # This would fail if uncommented          

```