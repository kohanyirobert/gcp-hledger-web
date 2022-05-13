# About

Container to run [`hledger-web`](https://hledger.org/1.25/hledger-web.html) on Google Cloud Run with ledger file stored on Google Cloud Storage.

## Notes

### General

- Uses [`gcsfuse`](https://github.com/GoogleCloudPlatform/gcsfuse)
- For some reason `gcsfuse` can [only works with `root` on Cloud Run](https://serverfault.com/questions/1100860/gcsfuse-failed-to-open-dev-fuse-permission-denied)
- If started locally with `docker run` the `--priviliged` must be used

### Service Account

- The service account used during deployment should use the following roles
  - Cloud Run Viewer
  - Storage Object Admin
  - Service Account User

### GitHub Actions

- The *Deploy* workflow deploys the service, but it cannot make it publicly accessible or set that it should use the 2nd generation execution environment, **these must be set manually**
- The service account used by the workflow must have Storage Admin permission (to be able to create a new registry)
- Set the following secrets
  - `GCP_CREDENTIALS_JSON` - the value of this should the JSON credentials file's contents created for the service account used by the workflow
  - `GCP_REGION`
  - `GCP_PROJECT`
  - `GCP_SERVICE`
  - `GCP_ENV_VARS` - this will be passed to the Cloud Run service started by the workflow, its value should be something similar to this `GCP_REGION=us-west1,GCP_PROJECT=<project>,GCP_SERVICE=<service>,GCSFUSE_MAX_RETRY_SLEEP=10s,GCS_BUCKET_NAME=hledger,GCS_LEDGER_OBJECT_NAME=.hledger.journal,OAUTH2_PROXY_COOKIE_SECRET=<secret>,OAUTH2_PROXY_CLIENT_ID=<id>,OAUTH2_PROXY_CLIENT_SECRET=<secret>,OAUTH2_PROXY_AUTHENTICATED_EMAILS=<email>`

## Environment variables

- `PORT` - Cloud Run injects this into the environment, used by `hledger-web`
- `GCP_REGION` - region to use in order to fetch instance metadata via `curl`
- `GCP_PROJECT` - project to use in order to fetch instance metadata via `curl`
- `GCP_SERVICE` - service to use in order to fetch instance metadata via `curl`
- `GCSFUSE_MAX_RETRY_SLEEP` - max. seconds `gcsfuse` waits before failing
- `GCS_BUCKET_NAME` - Cloud Storage bucket name where the ledger is stored
- `GCS_LEDGER_OBJECT_NAME` - the object name in the bucket used for the ledger
- `OAUTH2_PROXY_COOKIE_SECRET`
- `OAUTH2_PROXY_CLIENT_ID`
- `OAUTH2_PROXY_CLIENT_SECRET`
- `OAUTH2_PROXY_AUTHENTICATED_EMAILS`
