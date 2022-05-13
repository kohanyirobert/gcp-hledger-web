# About

Container to run [`hledger-web`](https://hledger.org/1.25/hledger-web.html) on Google Cloud Run with ledger file stored on Google Cloud Storage.

## Notes

- Uses [`gcsfuse`](https://github.com/GoogleCloudPlatform/gcsfuse)
- For some reason `gcsfuse` can [only works with `root` on Cloud Run](https://serverfault.com/questions/1100860/gcsfuse-failed-to-open-dev-fuse-permission-denied)
- If started locally with `docker run` the `--priviliged` must be used
- The service account used during deployment should use the following roles
  - Cloud Run Viewer
  - Storage Object Admin

## Environment variables

- `PORT` - Cloud Run injects this into the environment, used by `hledger-web`
- `GCP_REGION` - region to use in order to fetch instance metadata via `curl`
- `GCP_PROJECT` - project to use in order to fetch instance metadata via `curl`
- `GCP_SERVICE` - service to use in order to fetch instance metadata via `curl`
- `GCSFUSE_MAX_RETRY_SLEEP` - max. seconds `gcsfuse` waits before failing
- `GCS_BUCKET_NAME` - Cloud Storage bucket name where the ledger is stored
- `GCS_LEDGER_OBJECT_NAME` - the object name in the bucket used for the ledger
