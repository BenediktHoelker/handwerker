import type { Request } from '@sap/cds/apis/services';
import { Service } from '@sap/cds/apis/services';
import { S3 } from 'aws-sdk';
import { UUID } from 'aws-sdk/clients/cloudtrail';

const s3 = new S3({
  accessKeyId: process.env.BUCKETEER_AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.BUCKETEER_AWS_SECRET_ACCESS_KEY,
  region: process.env.BUCKETEER_AWS_REGION
});

export = async (srv: Service): Promise<void> => {
  // eslint-disable-next-line func-names
  srv.on('getUserInfo', async (req: Request) => {
    const email = req.user.email || 'john.doe@web.de';
    return { email };
  });

  srv.before('CREATE', 'Files', (req) => {
    req.data.url = `/attachments/Files(${req.data.ID})/content`;
  });

  srv.on('UPDATE', 'Attachments', async (req: Request) => {
    const params = {
      Bucket: process.env.BUCKETEER_BUCKET_NAME,
      Key: req.data.ID,
      Body: req.data.content
    };

    await new Promise((resolve, reject) => {
      s3.upload(params, (err: any, data: any) => {
        if (err) {
          reject(err);
        }
        resolve(data.Location);
      });
    });

    return req.data.content;
  });

  srv.on('READ', 'Attachments', (req, next) => {
    if (!req.data.ID) {
      return next();
    }

    return {
      value: _getObjectStream(req.data.ID)
    };
  });

  /* Get object stream from S3 */
  function _getObjectStream(objectKey: UUID) {
    const params = {
      Bucket: process.env.BUCKETEER_BUCKET_NAME,
      Key: objectKey
    };
    return s3.getObject(params).createReadStream();
  }
};
