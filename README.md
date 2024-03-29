<h1 align="center">
  HelpMeOut 👩🏻‍⚕️
</h1>

<br />

# The project

HelpMeOut is a simple P.O.C to show how two apps can communicate in realtime using Firebase as a backend.
The apps are Universal Apps and can run both on iPhone and iPad.

The project is composed by:

- 1 Caregiver app
- 1 Patient app
- Firebase cloud functions

Both the Patients and the Caregivers can authenticate in the apps using phone number or email.

Patients can add one or more caregivers and wait for their approval.

Caregivers receive the patients requests and can accept them or not.

Patients can then send SOS request to they caregivers (those that accepted the request).


## Compiling
- Enter into the folder apps (`helpmeout-caregiver`, `helpmeout-patients`).
- `pod install`
- Open the `\*.xcworkspace` in XCode and compile. To run the apps on a physical device you'll have to provide some valid provisioning profiles with **push notifications option enabled**.

## Push notifications
In order to have push notifications working you need to get - from Apple Developer - an APNs key (Section: Keys) for each app. These keys will then be used on the Firebase console too.

## Firebase configuration
Configuring Firebase takes some time...
- The XCode projects already contain a working Firebase configuration, then **it's not mandatory to create a new one**.
- Open the console (https://console.firebase.google.com) and create a new project, give it a name (HelpMeOut).
- **Add your iOS apps**, using 2 differents bundleId (E.G: com...-patient, com...-caregiver).
- For each app, download the configuration .plist. This configuration must then be added to your xcode project.
- For each app, in section *Cloud Messaging*, add the APNs Key you downloaded before. This will link Firebase to your apps and will let you send and receive push notifications.
- **Authentication**. Go to Authentication/Methods and enable *Email* and *Phone*. These are the 2 only methods available in the apps.
- **Database**. Create a new Realtime Database under *Database* section.
- Rules. Just to speed up queries there are 2 simple indexes to apply on some database paths. You can go to folder `FIRCloudFunctions` and copy them from the `firebase-rules.json` file. BTW, they are not mandatory.
- **CloudFunctions**. In order to trigger push notifications and to generate IDs there are some functions to upload to the database. Go to folder `FIRCloudFunctions/functions` and deploy them with `npm install`, `firebase deploy`.

## Architecture
The apps are built on MVVM+C architecture. The choice is a perfect balance between simplicity and testability and avoids both (too much) boilerplate code (VIPER) and massive view controllers (MVC).
Since the 2 apps are very similar, I decided to share some code between them but to keep them as a two separate projects, in order to preserve a future indipendent scalability.

TODO: Put the shared code in a POD.

On the backend side, the only thing to notice is the users ID number generator: **I decided for a shortID algorithm, easy to generate BUT probably not so easy for users to type**.

**IMPORTANT! TODO**: implement a synchronized sequence number generator.


## Testing
Testing the app requires to launch a local Firebase server.
- Cd into `FIRCloudFunctions/test-server` folder.
- `npm install`
- `npm start`
- Run tests on XCode as usual.

NOTE: for some weird (documented) reasons the Firebase local server works only if you add the local address to `/etc/hosts`

`127.0.0.1 test.firebase.localhost`

### Notes on testing
- Testing a realtime DB is not an easy task: you have to deal with async callbacks and there could be unexpected side-effects. What I did here is to test just some methods. TODO: Test ALL cloud & model methods.
- Testing approach: the easiest possible. Write & read back on a local db, recreating the db each time.
- TODO: a better testing approach: mock all the Firebase calls to get more fine control and not to rely on a physical db.

