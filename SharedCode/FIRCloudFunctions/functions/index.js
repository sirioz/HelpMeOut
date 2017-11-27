'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const shortid = require('shortid');

admin.initializeApp(functions.config().firebase);

function buildPushPayload(title, body) {
  return {
    notification: {
      title: title,
      body: body,
      sound: 'default'
    }
  }
}

exports.sendCaregiverAcceptedNotification = functions.database.ref('/patients/{patientId}/caregivers/{cgShortId}/waiting').onWrite(event => {
  let patientId = event.params.patientId
  let cgShortId = event.params.cgShortId
  if (!event.data.exists()) {
    return false
  }
  if (event.data.val() == false) {
    return admin.database().ref(`/patients/${patientId}/pushToken`).once('value').then(snapshot => {
      let token = snapshot.val()
      let payload = buildPushPayload('Caregiver notification',`Caregiver '${cgShortId}' accepted to take care of you.`)
      console.info("Sending message to: "+token)
      console.info("Payload: "+JSON.stringify(payload))
      return admin.messaging().sendToDevice([token], payload).then(response => {
        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            console.error('Failure sending notification to', tokens[index], error);
          }
        })
      })
    })
  } else {
    console.info("Nothing to do")
    return false
  }

})

exports.assignPatientId = functions.database.ref('/patients/{uId}').onCreate(event => {
  let shortId = shortid.generate()
  console.log('shortId: '+shortId)
  return event.data.ref.child('shortId').set(shortId)
})

exports.assignCaregiverId = functions.database.ref('/caregivers/{uId}').onCreate(event => {
  let shortId = shortid.generate()
  console.log('shortId: '+shortId)
  return event.data.ref.child('shortId').set(shortId)
})

exports.sendSosRequests = functions.database.ref('/sosRequests/{patientId}/requests/{reqId}').onCreate(event => {
  let patientId = event.params.patientId
  if (!event.data.exists()) {
    return false
  }
  if (event.data.val().timeStamp > 0) {
    console.info("Nothing to do")
    return false
  }

  let ts = admin.database.ServerValue.TIMESTAMP
  return event.data.ref.child('timeStamp').set(ts)

})