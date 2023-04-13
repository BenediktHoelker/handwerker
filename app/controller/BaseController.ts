import ResourceModel from 'sap/ui/model/resource/ResourceModel';
import Router from 'sap/m/routing/Router';
import History from 'sap/ui/core/routing/History';
import Controller from 'sap/ui/core/mvc/Controller';
import UIComponent from 'sap/ui/core/UIComponent';
import Model from 'sap/ui/model/Model';
import ToolPage from 'sap/tnt/ToolPage';

/**
 * @namespace handwerker.controller.BaseController
 */
export default abstract class BaseController extends Controller {
  getRootComponent() {
    const uiComponent = this.getOwnerComponent() as any;
    return uiComponent.oContainer
      .getParent()
      .getParent()
      .getController()
      .getOwnerComponent();
  }

  /**
   * Convenience method for accessing the router in every controller of the application.
   * @public
   * @returns {sap.ui.core.routing.Router} the router for this component
   */
  getRouter() {
    const ownerComponent = this.getOwnerComponent() as UIComponent;
    return ownerComponent.getRouter() as Router;
  }

  /**
   * Convenience method for getting the view model by name in every controller of the application.
   * @public
   * @param {string} name the model name
   * @returns {sap.ui.model.Model} the model instance
   */
  getModel(name?: string) {
    return (
      this.getView().getModel(name) ||
      this.getOwnerComponent().getModel(name) ||
      this.getRootComponent().getModel(name)
    );
  }

  /**
   * Convenience method for setting the view model in every controller of the application.
   * @public
   * @param {sap.ui.model.Model} model the model instance
   * @param {string} name: string the model name
   * @returns {sap.ui.mvc.View} the view instance
   */
  setModel(model: Model, name: string) {
    return this.getView().setModel(model, name);
  }

  /**
   * Convenience method for getting the resource bundle.
   * @public
   * @returns {sap.ui.model.resource.ResourceModel} the resourceModel of the component
   */
  getResourceBundle() {
    const resourceModel = this.getOwnerComponent().getModel(
      'i18n'
    ) as ResourceModel;
    return resourceModel.getResourceBundle();
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

  onNavBack() {
    const sPreviousHash = History.getInstance().getPreviousHash();

    if (sPreviousHash !== undefined) {
      // eslint-disable-next-line no-restricted-globals
      history.go(-1);
    } else {
      this.getRouter().navTo('home', {}, {}, true);
    }
  }
}
