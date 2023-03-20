// eslint-disable-next-line func-names
module.exports = cds.service.impl(async function () {
  this.on('getUserInfo', async (req) => {
    const { email, name } = req.user;
    return { email: 'john.doe@web.de', name: 'John Doe' };
  });
});