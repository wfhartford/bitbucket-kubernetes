#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

password() {
  dd if=/dev/urandom bs=30 count=1 status=none | base64 -w 0
}

passwordB64() {
  password | base64 -w 0
}

ADMIN_PASSWORD=$(password)

echo "Bitbucket admin user password will be '${ADMIN_PASSWORD}'"
if [[ -f bitbucket-setup-secret.yaml ]]
then
  BITBUCKET_LICENSE=$(cat bitbucket-setup-secret.yaml | shyaml get-value 'data.bitbucket-license')
else
  unset BITBUCKET_LICENSE
fi

if [[ -z ${BITBUCKET_LICENSE+x} ]]
then
  BITBUCKET_LICENSE="[insert license here]"
  echo "Remember to add your bitbucket license key into bitbucket-setup-secret.yaml"
fi

cat > bitbucket-setup-secret.yaml << EOF
# This secret contains secrets only required when bitbucket starts for the
# first time, once bitbucket has started and the admin can log in, this secret
# can be permanently deleted.
apiVersion: v1
kind: Secret
metadata:
  namespace: bitbucket
  name: bitbucket-setup
type: Opaque
data:
  # The base64 encoded bitbucket license provided by Atlassian.
  bitbucket-license: ${BITBUCKET_LICENSE}
  # The user name of the admin user created at first startup ("admin").
  bitbucket-admin-user: YWRtaW4=
  # The password of the above named admin user created at first startup.
  bitbucket-admin-password: $(echo -n ${ADMIN_PASSWORD} | base64 -w 0)
EOF

cat > postgres-secret.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  namespace: bitbucket
  name: postgres
type: Opaque
data:
  # The password used by bitbucket to access postgres, required every time
  # bitbucket runs.
  password: $(passwordB64)
EOF
