#!/usr/bin/env bash
INCLUDE='"include": [{
            "db-service": "postgresql14",
            "DB_EXTRAS": "postgresql"
          }, {
            "db-service": "mysql8",
            "DB_EXTRAS": "mysql"
          }, {
            "search-service": "opensearch2",
            "SEARCH_EXTRAS": "opensearch2"
          }]'
PYTHON_VERSIONS=$(
  grep "Programming Language :: Python ::" setup.cfg |
    sed -E "s/^.*::\s(.*)$/\1/" |
    tr "\n" " " |
    xargs |
    sed -E -e 's/\s/","/g' -e 's/^/["/' -e 's/$/"]/')
DB=$(
  if grep -q "invenio-db" setup.cfg
  then
    echo '"db-services": ["postgresql14", "mysql8"], '
  else
    echo ''
  fi)
SEARCH=$(
  if grep -q "invenio-search" setup.cfg
  then
    echo '"search-services": ["opensearch1"], '
  else
    echo ''
  fi)
matrix=$(
  echo "{ \"requirements-level\": [\"pypi\"], \"python-version\": $PYTHON_VERSIONS, $DB $SEARCH $INCLUDE }" | jq -c .
      )
echo "$matrix"
