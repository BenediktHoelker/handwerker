sap.ui.define(
  [
    // "../Authentication",
    './BaseController',
    'sap/ui/model/json/JSONModel'
  ],
  (BaseController, JSONModel) =>
    BaseController.extend('handwerker.controller.App', {
      onInit() {},

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
        // navTo($event, "trackViaCalendar&/calendar/singleEntry");
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
      },

      collapseExpandSideNavigation() {
        const toolPage = this.getView().byId('toolPage');
        const isExpanded = toolPage.getSideExpanded();
        toolPage.setSideExpanded(!isExpanded);
      }
    })
);
