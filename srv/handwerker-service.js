// eslint-disable-next-line func-names
module.exports = cds.service.impl(async function () {
  const db = await cds.connect.to('db');
  const { Orders } = db.entities('handwerker');

  this.on('getUserInfo', async (req) => {
    const email = req.user.email || 'john.doe@web.de';
    return { email };
  });

  // this.on('WRITE', 'Orders', async (req) => {db});
});
