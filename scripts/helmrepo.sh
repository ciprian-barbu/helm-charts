#!/usr/bin/env bash

# Copyright 2018-present Open Networking Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# helmrepo.sh
# creates a helm repo for publishing on guide website

set -e -u -o pipefail

REPO_DIR="${REPO_DIR:-chart_repo}"

GERRIT_BRANCH="${GERRIT_BRANCH:-$(git symbolic-ref --short HEAD)}"
PUBLISH_URL="${PUBLISH_URL:-https://guide.opencord.org/charts/${GERRIT_BRANCH}}"

mkdir -p "${REPO_DIR}"

for chart in $(find . -name Chart.yaml -print) ; do

  chartdir=$(dirname "${chart}")

  echo "Adding ${chartdir}"

  helm package --dependency-update --destination "${REPO_DIR}" "${chartdir}"

done

echo "Generating repo index"

helm repo index "${REPO_DIR}" --url "${PUBLISH_URL}"

echo "Finished, chart repo generated: ${REPO_DIR}"

