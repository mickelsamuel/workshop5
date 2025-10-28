#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${PROJECT_ID:-}" || -z "${REGION:-}" || -z "${SERVICE:-}" ]]; then
  echo "Please export PROJECT_ID, REGION, and SERVICE before running."
  echo "Example:"
  echo "  export PROJECT_ID=<GCP_PROJECT_ID>"
  echo "  export REGION=<GCP_REGION>"
  echo "  export SERVICE=<SERVICE_NAME>"
  exit 1
fi

ARTIFACT_REPO=workshop5
SA_NAME=gh-actions-deployer
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "-> Enabling required APIs..."
gcloud services enable run.googleapis.com artifactregistry.googleapis.com iam.googleapis.com

echo "-> Configuring gcloud default project & region..."
gcloud config set project "${PROJECT_ID}"
gcloud config set run/region "${REGION}"

echo "-> Creating Artifact Registry repo (idempotent)..."
gcloud artifacts repositories create "${ARTIFACT_REPO}" \
  --repository-format=docker \
  --location="${REGION}" \
  --description="Workshop5 Docker repo" || true

echo "-> Creating service account (idempotent)..."
gcloud iam service-accounts create "${SA_NAME}" --display-name="GitHub Actions Deployer" || true

echo "-> Granting roles to service account..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.writer"

echo "-> Creating a JSON key (writes to ./sa-key.json)..."
gcloud iam service-accounts keys create ./sa-key.json \
  --iam-account="${SA_EMAIL}"

echo ""
echo "Bootstrap complete!"
echo "1) Open GitHub > repo > Settings > Secrets and variables > Actions"
echo "   - Add secret GCP_PROJECT_ID = ${PROJECT_ID}"
echo "   - Add secret GCP_SA_KEY = (paste contents of ./sa-key.json)"
echo "2) Commit and push to main to trigger deployment."
