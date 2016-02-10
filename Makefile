PROJECT = photoboard.xcodeproj

.PHONY: build clean test

clean:
	xcodebuild -project $(PROJECT) clean

build:
	xcodebuild -project $(PROJECT) -scheme photoboard -configuration Debug build

test:
	xcodebuild -project $(PROJECT) -scheme photoboardTests -destination 'platform=iOS Simulator,name=iPhone 6' test
