import JSONModel from 'sap/ui/model/json/JSONModel';
import BaseController from './BaseController';
import ToolPage from 'sap/tnt/ToolPage';
import { Users } from '../metadata';

/**
 * @namespace handwerker
 */
export default class App extends BaseController {
  public onInit() {
    const viewModel = new JSONModel({
      user: '',
      splitAppMode: 'ShowHideMode'
    });

    this.getView().setModel(viewModel, 'appVM');

    this.getModel().callFunction('/getUserInfo', {
      success: (user: Users) => {
        viewModel.setProperty('/user', user.email);
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
          route: 'SettingsObjectPage'
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
