const logger = require("firebase-functions/logger");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require('firebase-admin');
const {onSchedule} = require("firebase-functions/v2/scheduler");


var serviceAccount = require("./serviceAccountKey.json");

initializeApp({
    credential: admin.credential.cert(serviceAccount)
});



exports.deleteExpiredCampaigns = onSchedule('every 5 minutes', async (event) => {
    const db = getFirestore();
    const now = Timestamp.now();

    try {
        const campaignsRef = db.collection('campaigns');
        const snapshot = await campaignsRef.where('end', '<', now).get();

        if (snapshot.empty) {
            logger.info('No expired campaigns found.');
            return;
        }

        logger.info(`Found ${snapshot.size} expired campaigns.`);

        snapshot.forEach(doc => {
            doc.ref.delete();
        });
    } catch (error) {
        logger.error('Error fetching campaigns:', error);
    }
});

exports.updateCampaignDataOnProfileUpdate = onDocumentUpdated('partners/{partnerID}', async (event) => {

    if (!event.data.after) {
        return;
    }

    const before = event.data.before.data();
    const after = event.data.after.data();

    var hasChangesFound = false;

    if (before !== after) {
        hasChangesFound = true;
    }

    if (hasChangesFound) {
        // Get all campaigns of the partner
        const partnerID = event.params.partnerID;
        const db = getFirestore();
        const campaignsRef = db.collection('campaigns').where('companyID', '==', partnerID);
        const campaigns = await campaignsRef.get();

        // Update the campaigns
        campaigns.forEach(async (doc) => {
            await doc.ref.update({
                category: after.category,
                companyImage: after.imageUrl,
                companyName: after.name,
                isVisible: after.accessLevel == 'pro' ? true : false,
            });
        });

        logger.info(`Updated ${campaigns.size} campaigns for partner: ${partnerID}`);
    }

});
