## HelpMeOut - The project
The project is composed by:

- 1 Caregiver app
- 1 Patient app
- Firebase cloud functions

## Compiling
- Enter into the folder apps (helpmeout-caregiver, helpmeout-patients)
- pod init
- Open the \*.xcworkspace in XCode and compile. To run the apps on a physical device you'll have to provide some valid provisioning profiles with **push notifications option enabled**.

## Push notifications
In order to have push notifications working you need to get - from Apple Developer - an APNs key (Section: Keys) for each app. These keys will then be used on the Firebase console too.

## Firebase configuration
Configuring Firebase takes some time...
- Open the console (https://console.firebase.google.com) and create a new project, give it a name (HelpMeOut)
- Add your iOS apps, using 2 different bundleId (E.G: com...-patient, com...-caregiver).
- For each app, download the configuration .plist. This configuration must then be added to your xcode project.
- For each app, in section *Cloud Messaging*, add the APNs Key you downloaded before. This will link Firebase to your apps and will let you receive push notifications
- **Authentication**. Go to Authentication/Methods and enable *Email* and *Phone*. These are the 2 only methods available in the apps.

## Testing
Testing the app requires to launch a local Firebase server.
- Cd into FIRCloudFunctions/test-server folder
- npm install
- npm start

NOTE: for some weird (documented) reasons the Firebase local server works only if you add the local address to /etc/hosts

127.0.0.1 test.firebase.localhost

## Notes on testing
- Testing a realtime DB is not simple, you have to deal with async callbacks and there could be unexpected side-effects. What I did here is to test just some methods. TODO: Test ALL cloud & model methods.
- Testing approach, the simplest possible. Write & read back on a local db, recreating the db each time.
- TODO: better testing approach: mock all the Firebase calls to get more fine control and not rely on a phisical db.

# Documentation still in progres...
