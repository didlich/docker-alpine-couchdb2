#!/bin/sh

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
addgroup -g $USER_ID user && adduser -D -G user -s /bin/false -u $USER_ID user
export HOME=/home/user

chown -R user:user /opt/couchdb

# start couchdb with user 'user'
su-exec user /opt/couchdb/bin/couchdb