# MultiProcessApp
Mini project demonstrating two issues in the YapDatabase related to multiprocess support

Steps to reproduce the bug:
1. Open the app and background
2. Send a push notification with a following payload
3. Reopen the backgrounded app

There are 2 issues:
  a) Crash because mismatched mappings and notifications
  b) The database connections caches are out of sync
  
