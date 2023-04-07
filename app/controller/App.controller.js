sap.ui.define(
  ['./BaseController', 'sap/ui/model/json/JSONModel'],
  (BaseController, JSONModel) =>
    BaseController.extend('handwerker.controller.App', {
      onInit() {
        const viewModel = new JSONModel({
          user: '',
          splitAppMode: 'ShowHideMode'
        });

        this.getView().setModel(viewModel, 'viewModel');

        this.getModel().callFunction('/getUserInfo', {
          success: (result) => {
            const email = result.getUserInfo.email;
            viewModel.setProperty('/user', email);
          }
        });
      },

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

        const device = this.getModel('device');
        const toolPage = this.getView().byId('toolPage');

        if (device.getProperty('/system/phone')) {
          toolPage.setSideExpanded(false);
        }
      },

      navToSettings() {
        // navTo($event, "trackViaCalendar&/calendar/singleEntry");
        this.getOwnerComponent()
          .getRouter()
          .navTo(
            'changeSettings',
            {},
            {
              changeSettings: {
                route: 'SettingsObjectPage',
                parameters: {
                  key: "tenant='john.doe@web.de',IsActiveEntity=true"
                }
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

      toggleSideNavigation() {
        const toolPage = this.getView().byId('toolPage');
        const isExpanded = toolPage.getSideExpanded();
        toolPage.setSideExpanded(!isExpanded);
      }
    })
);
