# workshop5 – Cloud Run via GitHub Actions

This is a minimal Flask service deployed to Google Cloud Run using GitHub Actions for CI/CD.

**Pipeline:** GitHub → Actions → Cloud Build → Deploy to Cloud Run

## Live Deployment

🌐 **Live Service URL:** https://workshop5-e46i7fiqiq-uc.a.run.app

📦 **GCP Project ID:** workshop5-476515

🔄 **Status:** Deployed and running on Google Cloud Run

## Prerequisites
- Google Cloud account with billing enabled
- Google Cloud CLI installed locally
- GitHub repository

## Local quickstart
```bash
# build and run locally
docker build -t workshop5:local .
docker run -e PORT=8080 -p 8080:8080 workshop5:local
curl http://localhost:8080
```

## Required GitHub Configuration

### Repository Variables (Settings → Secrets and variables → Actions → Variables)
- `PROJECT_ID` = your GCP project ID

### Repository Secrets (Settings → Secrets and variables → Actions → Secrets)
- `GCP_SA_CREDENTIAL_JSON` = contents of the service account JSON key file

## Deployment
Every push to the `main` branch automatically triggers deployment to Cloud Run.
