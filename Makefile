PROJECT = photoboard.xcodeproj
TEST_TARGET = photoboardTests
SDK = iphonesimulator
CONFIGURATION = Debug

clean:
	xcodebuild -project $(PROJECT) clean

test:
	xcodebuild -project $(PROJECT) -target $(TEST_TARGET) -sdk $(SDK) -configuration $(CONFIGURATION) TEST_AFTER_BUILD=YES
