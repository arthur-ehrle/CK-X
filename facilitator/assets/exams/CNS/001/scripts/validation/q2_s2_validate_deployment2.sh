#!/bin/bash
# Validate if Deployment exists with correct configuration

DEPLOYMENT_NAME="deploy-2"
EXPECTED_REPLICAS=1
EXPECTED_IMAGE="nginx"
EXPECTED_CONTAINER_NAME="c1"

# Check if Deployment 1 exists
if ! kubectl get deployment $DEPLOYMENT_NAME &> /dev/null; then
    echo "❌ Deployment '$DEPLOYMENT_NAME' not found"
    exit 1
fi

# Check if correct number of replicas
REPLICAS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.replicas}')
if [ "$REPLICAS" != "$EXPECTED_REPLICAS" ]; then
    echo "❌ Deployment '$DEPLOYMENT_NAME' has incorrect number of replicas: $REPLICAS (expected: $EXPECTED_REPLICAS)"
    exit 1
fi

# Check if correct image is used
POD_IMAGE=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$POD_IMAGE" != "$EXPECTED_IMAGE" ]; then
    echo "❌ Deployment '$DEPLOYMENT_NAME' using incorrect image: $POD_IMAGE (expected: $EXPECTED_IMAGE)"
    exit 1
fi

# Check if deployment is available
AVAILABLE=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.availableReplicas}')
if [ "$AVAILABLE" != "$EXPECTED_REPLICAS" ]; then
    echo "❌ Deployment '$DEPLOYMENT_NAME' is not fully available (available: $AVAILABLE, expected: $EXPECTED_REPLICAS)"
    exit 1
fi

# Check if correct container name is used
CONTAINER_NAME=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.template.spec.containers[0].name}')
if [ "$CONTAINER_NAME" != "$EXPECTED_CONTAINER_NAME" ]; then
    echo "❌ Deployment '$DEPLOYMENT_NAME' using incorrect container name: $CONTAINER_NAME (expected: $EXPECTED_CONTAINER_NAME)"
    exit 1
fi

echo "✅ Deployment '$DEPLOYMENT_NAME' exists with correct configuration"
exit 0 