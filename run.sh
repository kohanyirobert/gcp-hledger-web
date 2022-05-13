#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
gcsfuse --foreground --max-retry-sleep "$GCSFUSE_MAX_RETRY_SLEEP" "$GCS_BUCKET_NAME" /data &
ledger_file="/data/$GCS_LEDGER_OBJECT_NAME"
[ ! -f "$ledger_file" ] || touch "$ledger_file"
access_token=$(curl -sH "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
  | jq -r '.access_token')
base_url=$(curl -sH "Authorization: Bearer $access_token" "https://$GCP_REGION-run.googleapis.com/apis/serving.knative.dev/v1/namespaces/$GCP_PROJECT/services/$GCP_SERVICE" \
  | jq -r '.status.address.url')
echo "$OAUTH2_PROXY_AUTHENTICATED_EMAILS" > authenticated-emails.txt
oauth2-proxy \
  --http-address=0.0.0.0:$PORT \
  --cookie-secret="$OAUTH2_PROXY_COOKIE_SECRET" \
  --client-id="$OAUTH2_PROXY_CLIENT_ID" \
  --client-secret="$OAUTH2_PROXY_CLIENT_SECRET" \
  --config=oauth2-proxy.cfg &
hledger-web --serve --base-url=$base_url --file=$ledger_file &
wait -n
