pushd android
# # flutter build generates files in android/ for building the app
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart
popd

gcloud auth activate-service-account --key-file=wiredbraincoffee-a1386-4485fb96c69f.json

gcloud --quiet config set project wiredbraincoffee-a1386	

gcloud firebase test android run --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --timeout 2m \
  # --results-bucket=<RESULTS_BUCKET> \
  # --results-dir=<RESULTS_DIRECTORY>




















