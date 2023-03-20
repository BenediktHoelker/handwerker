import UIComponent from 'sap/ui/core/UIComponent';
import models from './model/models';

/**
 * @namespace handwerker.components.orders
 */
export default class Component extends UIComponent {
  public static metadata = {
    manifest: 'json'
  };

  public init(): void {
    // call the base component's init function
    super.init();

    this.setModel(models.createDeviceModel(), 'device');

    // create the views based on the url/hash
    this.getRouter().initialize();
  }
}
