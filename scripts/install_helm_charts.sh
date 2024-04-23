helm repo add riskfocus https://riskfocus.github.io/helm-charts-public
helm repo update
helm install my-flink riskfocus/flink --namespace flink --create-namespace

# creating port 
sudo bash -c 'cat <<EOF > /home/ubuntu/minikube_port_forward.sh
#!/bin/bash

# Ensure kubectl context is set correctly
kubectl config use-context minikube

# Start port forwarding for each service -- add more lines here as required
kubectl port-forward -n flink service/my-flink-jobmanager 8081:8081 &

# Wait indefinitely to keep the script running
wait
EOF'

# make script executable
sudo chmod +x /home/ubuntu/minikube_port_forward.sh

# restart port forwarding service
sudo systemctl daemon-reload
sudo systemctl restart minikube-port-forward.service
