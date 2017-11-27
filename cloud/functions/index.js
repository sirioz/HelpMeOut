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
  let patientId = event.params.patientId;
  let cgShortId = event.params.cgShortId;
  if (!event.data.exists()) {
    return;
  }
  if (event.data.val() == false) {
    return admin.database().ref(`/patients/${patientId}/pushToken`).once('value').then(snapshot => {
      let token = snapshot.val()
      let payload = buildPushPayload('Caregiver notification',`Caregiver '${cgShortId}' accepted to take care of you.`)
      return admin.messaging().sendToDevice([token], payload).then(response => {
        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            console.error('Failure sending notification to', tokens[index], error);
          }
        })
      })
    })
  }

})
  
exports.assignPatientId = functions.database.ref('/patients/{patientId}/shortId').onWrite(event => {
  let patientId = event.params.patientId
  if (!event.data.exists()) {
    return false;
  }
  if (event.data.val().length == 0 ) {
    let shortId = shortid.generate()
    console.log('shortId: '+shortId)
    return admin.database().ref(`/patients/${patientId}`).update({shortId})
  }
  return false
})