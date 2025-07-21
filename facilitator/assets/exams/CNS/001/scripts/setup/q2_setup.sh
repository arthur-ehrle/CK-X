#!/bin/bash

# Create namespace if it doesn't exist
kubectl create namespace internal 2>/dev/null || true