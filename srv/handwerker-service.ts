import type { Request } from '@sap/cds/apis/services';
import { Service } from '@sap/cds/apis/services';

export = async (srv: Service): Promise<void> => {
  // eslint-disable-next-line func-names
  srv.on('getUserInfo', async (req: Request) => {
    const email = req.user.email || 'john.doe@web.de';
    return { email };
  });

  // this.on('WRITE', 'Orders', async (req) => {db});
};
