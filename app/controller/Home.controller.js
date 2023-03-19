sap.ui.define(['sap/ui/core/mvc/Controller'], (Controller) =>
  Controller.extend('handwerker.controller.Home', {
    navTo(event, pattern, target, deepRoute) {
      let deepRoutingConfig = {};

      if (target) {
        deepRoutingConfig = {
          [target]: { route: deepRoute }
        };
      }
      this.getOwnerComponent()
        .getRouter()
        .navTo(pattern, {}, deepRoutingConfig);
    },

    navToMasterDetail() {
      this.getOwnerComponent()
        .getRouter()
        .navTo(
          'trackViaCalendar',
          {},
          {
            spc: {
              route: 'masterDetail'
            }
          }
        );
    },

    navToAnalytics(route) {
      this.getOwnerComponent().getRouter().navTo(
        'manageCategories',
        {},
        {
          manageCategories: {
            route
          }
        }
      );
    }
  })
);
