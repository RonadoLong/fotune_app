openIphone:
	flutter emulators --launch apple_ios_simulator

runIphone:
	flutter run -d iphone

release:
	sh build.sh