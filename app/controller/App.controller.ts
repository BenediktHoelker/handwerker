import JSONModel from 'sap/ui/model/json/JSONModel';
import BaseController from './BaseController';
import ToolPage from 'sap/tnt/ToolPage';

/**
 * @namespace handwerker
 */
export default class App extends BaseController {
  public onInit() {
    const viewModel = new JSONModel({
      user: '',
      splitAppMode: 'ShowHideMode'
    });

    this.getView().setModel(viewModel, 'viewModel');

    this.getModel().callFunction('/getUserInfo', {
      success: (result: any) => {
        const email = result.getUserInfo.email;
        viewModel.setProperty('/user', email);
      }
    });
  }

  navTo(event: UIEvent, pattern: string, target: string, deepRoute: string) {
    let deepRoutingConfig = {};

    if (target) {
      deepRoutingConfig = {
        [target]: { route: deepRoute }
      };
    }

    this.getRouter().navTo(pattern, {}, deepRoutingConfig);

    const device = this.getModel('device');
    const toolPage = this.getView().byId('toolPage') as ToolPage;

    if (device.getProperty('/system/phone')) {
      toolPage.setSideExpanded(false);
    }
  }

  navToSettings() {
    // navTo($event, "trackViaCalendar&/calendar/singleEntry");
    this.getRouter().navTo(
      'changeSettings',
      {},
      {
        // @ts-ignore
        changeSettings: {
          route: 'SettingsObjectPage',
          parameters: {
            key: "tenant='john.doe@web.de',IsActiveEntity=true"
          }
        }
      }
    );
  }

  toggleSideNavigation() {
    const toolPage = this.getView().byId('toolPage') as ToolPage;
    const isExpanded = toolPage.getSideExpanded();
    toolPage.setSideExpanded(!isExpanded);
  }
}
