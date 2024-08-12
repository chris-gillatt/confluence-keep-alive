#!/bin/bash -e 

test "$(command -v jq)" || ( echo "jq is not installed." && exit 1)

USER="${CONFLUENCE_USER_EMAIL}"
KEY="${CONFLUENCE_KEEP_ALIVE_TOKEN}"

if [ -z "$CONFLUENCE_USER_EMAIL" ] || \
   [ -z "$CONFLUENCE_KEEP_ALIVE_TOKEN" ]; then 
   echo "missing env vars"
   exit 1
fi

GET_RESPONSE=$(curl -s \
  -u "$USER":"$KEY"\
  -X GET \
  -H 'Accept: application/json' \
  'https://tucan.atlassian.net/wiki/rest/api/content/383090689?expand=body.storage')


TEST_PAGE_ID=$(echo "$GET_RESPONSE" | jq '.id')
TEST_PAGE_CONTENT=$(echo "$GET_RESPONSE" | jq '.body.storage.value' )

if [ -n "$TEST_PAGE_ID" ]; then
  echo "test page id: $TEST_PAGE_ID"
  echo "test page content: $TEST_PAGE_CONTENT"
else
  echo "unable to retrieve page"
  exit 1 
fi