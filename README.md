# MultiProcessApp
Mini project demonstrating two issues in the YapDatabase related to multiprocess support

Steps to reproduce the bug:
1. The app should be running in the background
2. Send a push notification with the following payload (mutable-content:1 should wake up the app extension)

    ````
    curl -v -d '{"aps":{"mutable-content":1,"badge":1,"alert":{"title-loc-key":"default_push_title","loc-key":"default_push_message"}}}' \
    -H "apns-topic: ch.adeya.latest" \
    -H "apns-expiration: 0" \
    -H "apns-priority: 10" \
    -H "apns-push-type: alert" --http2 \
    --cert voip-certificate.pem:ch.adeya.latest --key voip-key-certificate.pem \
    https://api.sandbox.push.apple.com:443/3/device/cd5eb454c5c32c1556b987196bbbda91cbdba1496881685e59f00da9bda73953
    ````
3. Reopen the backgrounded app

There are 2 issues:
  - Crash because mismatched mappings and notifications
  - The database connections caches are out of sync
  
