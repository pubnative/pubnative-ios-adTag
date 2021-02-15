# Variable Declarations
BASE_DIR=/tmp/circleci-artifacts
PRODUCT_NAME=AdTag
ADTAG_APP_NAME=$PRODUCT_NAME.app
ADTAG_APP_PATH=$BASE_DIR/$PRODUCT_NAME
ADTAG_APP=$ADTAG_APP_PATH/$ADTAG_APP_NAME
ADTAG_APP_ZIP_PATH=$BASE_DIR/AdTag.app.zip

# Show Current Versions
xcodebuild -showsdks

# Generate AdTag App
xcodebuild -arch x86_64 -sdk iphonesimulator -workspace AdTag.xcworkspace -scheme AdTag CONFIGURATION_BUILD_DIR=$ADTAG_APP_PATH -verbose

# Create a .zip AdTag App
zip -r $ADTAG_APP_ZIP_PATH $ADTAG_APP
