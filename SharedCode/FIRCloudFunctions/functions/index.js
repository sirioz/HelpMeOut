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

function caregiversForPatient(patientShortId) {
  return new Promise( (resolve, reject) => {
    admin.database().ref('/caregivers').orderByChild(`patients/${patientShortId}`).on('value', snapshot => {
      var caregivers = []      
      snapshot.forEach(child => {
        let uId = child.key
        let pushToken = child.val().pushToken
        caregivers.push({uId, pushToken})
      })
      resolve(caregivers)
    })
  })
}

// exports.test = functions.https.onRequest((req, res) => {
//   let shortId = req.query.shortId
//   caregiversForPatient(shortId).then(caregivers => {
//     res.send(caregivers)
//   })
// })

exports.sendCaregiverRequestNotification = functions.database.ref('/patients/{patientId}/caregivers/{cgShortId}').onCreate(event => {
  let cgShortId = event.params.cgShortId
  return event.data.ref.parent.parent.child('shortId').once('value').then(snapshot => {
    let patientShortId = snapshot.val()
    return admin.database().ref('/caregivers').orderByChild('shortId').equalTo(cgShortId).once('value').then(snapshot => {
      var token = null
      snapshot.forEach(child => {
        token = child.val().pushToken
        return true
      })
      if (!token) {
        console.error("PushToken not found")
        return false
      }
      let payload = buildPushPayload('Patient request',`Patient '${patientShortId}' asked to add you.`)
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
  })
})

exports.sendCaregiverAcceptedNotification = functions.database.ref('/patients/{patientId}/caregivers/{cgShortId}/waiting').onWrite(event => {
  let patientId = event.params.patientId
  let cgShortId = event.params.cgShortId
  if (!event.data.exists()) {
    return false
  }
  if (event.data.val() == false) {
    return admin.database().ref(`/patients/${patientId}/pushToken`).once('value').then(snapshot => {
      let token = snapshot.val()
      // Send notification
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

exports.sendSosRequests = functions.database.ref('/patients/{patientId}/sosRequests/{reqId}').onCreate(event => {
  let patientId = event.params.patientId
  if (!event.data.exists()) {
    return false
  }
  if (event.data.val().timeStamp > 0) {
    console.info("Nothing to do")
    return false
  }

  let ts = admin.database.ServerValue.TIMESTAMP
  return event.data.ref.child('timeStamp').set(ts).then(() => {
    return event.data.ref.parent.parent.child('shortId').once('value').then(snapshot => {
      let patientShortId = snapshot.val()
      let payload = buildPushPayload('SOS Request',`Patient '${patientShortId}' needs your help!`)
      console.info("Payload: "+JSON.stringify(payload))
      return caregiversForPatient(patientShortId).then(caregivers => {
        caregivers.forEach(caregiver => {
          // Add to caregiver's requests
          admin.database().ref(`/caregivers/${caregiver.uId}/sosRequests`).push({shortId: patientShortId, timeStamp: ts})
          
          // Send notification to caregiver
          return admin.messaging().sendToDevice([caregiver.pushToken], payload)  
        })
      })
    })
  })

})