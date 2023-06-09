const AWS = require('aws-sdk');

const s3 = new AWS.S3({
  accessKeyId: process.env.BUCKETEER_AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.BUCKETEER_AWS_SECRET_ACCESS_KEY,
  region: process.env.BUCKETEER_AWS_REGION
});

module.exports = cds.service.impl(async function () {
  // eslint-disable-next-line func-names
  this.on('getUserInfo', async (req) => {
    const email = req.user.email || 'john.doe@web.de';
    return { email };
  });

  this.before('CREATE', 'Files', (req) => {
    req.data.url = `/attachments/Files(${req.data.ID})/content`;
  });

  this.on('UPDATE', 'Attachments', async (req) => {
    const params = {
      Bucket: process.env.BUCKETEER_BUCKET_NAME,
      Key: req.data.ID,
      Body: req.data.content
    };

    await new Promise((resolve, reject) => {
      s3.upload(params, (err, data) => {
        if (err) {
          reject(err);
        }
        resolve(data.Location);
      });
    });

    return req.data.content;
  });

  this.on('READ', 'Attachments', (req, next) => {
    if (!req.data.ID) {
      return next();
    }

    return {
      value: _getObjectStream(req.data.ID)
    };
  });

  /* Get object stream from S3 */
  function _getObjectStream(objectKey) {
    const params = {
      Bucket: process.env.BUCKETEER_BUCKET_NAME,
      Key: objectKey
    };
    return s3.getObject(params).createReadStream();
  }
});
