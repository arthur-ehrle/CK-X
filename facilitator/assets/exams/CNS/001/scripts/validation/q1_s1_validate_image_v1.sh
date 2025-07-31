#!/bin/bash
# Validate script for Question 1, Step 1: Check if docker-speedrun:v1 image exists


# Check if pod exists

POD_NAME="testpod"
NAMESPACE="cns-lab"
EXPECTED_IMAGE="httpd"


# Check if correct image is used
POD_IMAGE=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].image}')
if [ "$POD_IMAGE" != "$EXPECTED_IMAGE" ]; then
    echo "❌ Pod '$POD_NAME' is using incorrect image: $POD_IMAGE (expected: $EXPECTED_IMAGE)"
    exit 1
fi
kubectl get pod $POD_NAME -n $NAMESPACE &> /dev/null
if [ $? -eq 0 ]; then
  echo "✅ Deployment '$POD_NAME' exists in namespace '$NAMESPACE'"
  exit 0
else
  echo "❌ Deployment '$POD_NAME' not found in namespace '$NAMESPACE'"
  exit 1
fi
exit 0 


