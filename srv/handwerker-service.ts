import type { Request } from '@sap/cds/apis/services';
import { Service } from '@sap/cds/apis/services';
import { S3 } from 'aws-sdk';

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
    console.log('Create called');
    console.log(JSON.stringify(req.data));
    req.data.url = `/attachments/Files(${req.data.ID})/content`;
  });

  srv.on('UPDATE', 'Attachments', async (req: Request) => {
    const params = {
      Bucket: process.env.BUCKETEER_BUCKET_NAME,
      Key: req.data.ID,
      Body: req.data.content
    };

    await s3.upload(params);

    return req.data.content;
  });

  // this.on('WRITE', 'Orders', async (req) => {db});
};
