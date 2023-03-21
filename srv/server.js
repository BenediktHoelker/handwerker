const cov2ap = require('@sap/cds-odata-v2-adapter-proxy');
const cds = require('@sap/cds');
const express = require('express');
const { auth, requiresAuth } = require('express-openid-connect');

const config = {
  authRequired: false, // deactivate auth for all routes
  auth0Logout: true, // logout from IdP
  authorizationParams: {
    // required to retrieve JWT including permissions (our roles)
    response_type: 'code',
    scope: 'openid',
    audience: 'https://handwerker-api.com',
    authority: 'https://dev-r6g55fz7.us.auth0.com/'
  }
};

cds.on('bootstrap', (app) => {
  // initialize openid-connect with auth0 configuration
  app.use(auth(config));
  app.use(cov2ap());
  // app.use('/v2', requiresAuth());
  app.use('/dist', requiresAuth(), express.static(__dirname + '/../dist'));
});

module.exports = cds.server;
