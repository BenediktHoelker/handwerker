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
    audience: 'https://handwerker-api.com'
  }
};

cds.on('bootstrap', (app) => {
  // initialize openid-connect with auth0 configuration
  if (!process.env.CDS_ENV === 'development') {
    app.use(auth(config));
    app.use('/', requiresAuth(), express.static(__dirname + '/../dist'));
    app.use('/v2', requiresAuth());
  }
  app.use(cov2ap());
});

module.exports = cds.server;
