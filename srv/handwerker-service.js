// eslint-disable-next-line func-names
module.exports = cds.service.impl(async function () {
  this.on('getUserInfo', async (req) => {
    const email = req.user.email || 'john.doe@web.de';
    return { email };
  });
});
