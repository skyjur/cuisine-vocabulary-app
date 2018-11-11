import * as functions from 'firebase-functions';
import * as vision from '@google-cloud/vision';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

export const ocrTaskOnCreate = functions.firestore.document('/ocrTasks/{id}')
    .onCreate(async (snapshot, context) => {
        const gsPath = await snapshot.get('gsPath');
        console.log(`ocrTaskOnCreate: ${context.params.id} / gsPath: ${gsPath}`)
        if (gsPath) {
            const client = new vision.v1.ImageAnnotatorClient();
            const result = await client.textDetection({
                image: {
                    source: {
                        gcsImageUri: gsPath
                    }
                },
                imageContext: {
                    languageHints: [
                        'zh'
                    ]
                }
            });

            return snapshot.ref.set({
                result: JSON.stringify(result)
            })
        }
        return snapshot
    });