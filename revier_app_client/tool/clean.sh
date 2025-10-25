GRADLE_VERSION=8.9.0
ORGANIZATION_NAME=de.revierapp
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )

flutter clean

chmod +x $PROJECT_ROOT/android/gradlew
$PROJECT_ROOT/android/gradlew --stop

rm -rf ~/.gradle/caches/build-cache-*
rm -rf ~/.gradle/caches/transforms-*

rm -rf $PROJECT_ROOT/android
rm -rf $PROJECT_ROOT/ios
rm -rf $PROJECT_ROOT/macos
rm -rf $PROJECT_ROOT/linux
rm -rf $PROJECT_ROOT/web
rm -rf $PROJECT_ROOT/windows

flutter clean
flutter pub get
dart run build_runner clean

flutter create . --platforms=android,windows,linux,web,macos,ios --org $ORGANIZATION_NAME

# Update NDK version in build.gradle.kts
GRADLE_FILE="$PROJECT_ROOT/android/app/build.gradle.kts"
echo "Updating NDK version in $GRADLE_FILE"

# Use sed to replace flutter.ndkVersion with the specific version
sed -i '' 's|ndkVersion = flutter.ndkVersion|ndkVersion = "27.2.12479018"|g' "$GRADLE_FILE"

echo "NDK version updated to 27.2.12479018"

chmod +x $PROJECT_ROOT/android/gradlew
# $PROJECT_ROOT/android/gradlew
# $PROJECT_ROOT/android/gradlew clean
# $PROJECT_ROOT/android/gradlew wrapper --gradle-version $GRADLE_VERSION --distribution-type all
# $PROJECT_ROOT/android/gradlew assembleDebug

# Add the CallbackActivity to AndroidManifest.xml
MANIFEST_FILE="$PROJECT_ROOT/android/app/src/main/AndroidManifest.xml"
echo "Adding CallbackActivity to $MANIFEST_FILE"

# Use sed to insert the activity before the closing </application> tag
sed -i '' 's|</activity>|</activity>\
        <activity\
            android:name="com.linusu.flutter_web_auth_2.CallbackActivity"\
            android:exported="true">\
            <intent-filter android:label="flutter_web_auth_2">\
                <action android:name="android.intent.action.VIEW" />\
                <category android:name="android.intent.category.DEFAULT" />\
                <category android:name="android.intent.category.BROWSABLE" />\
                <data\
                    android:scheme="de.revierapp.client"\
                    android:host="login-callback" />\
            </intent-filter>\
        </activity>|g' "$MANIFEST_FILE"

echo "CallbackActivity added to AndroidManifest.xml"



flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

$SCRIPT_DIR/update_localization.sh
$SCRIPT_DIR/generate_icons.sh