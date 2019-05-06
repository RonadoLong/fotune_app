#!/bin/bash

echo '<============== begin build android ==============>'
flutter build apk
rm /Users/ronado/Desktop/app-release.apk
mv build/app/outputs/apk/release/app-release.apk /Users/ronado/Desktop
echo '<============== end build android ==============>'

#build ios
echo '<============== begin build ios ==============>'
flutter build ios --release
rm -rf /Users/ronado/Desktop/Runner.app 
mv /Users/ronado/code/app_code/fotune_app/build/ios/iphoneos/Runner.app /Users/ronado/Desktop/Runner.app
echo '<============== end build ios ==============>'
