PROJECT = photoboard.xcodeproj

.PHONY: build clean test

clean:
	xcodebuild -project $(PROJECT) clean

build:
	xcodebuild -project $(PROJECT) -target photoboard -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO

test:
	xcodebuild -project $(PROJECT) -scheme photoboardTests -destination 'platform=iOS Simulator,name=iPhone 6' test
