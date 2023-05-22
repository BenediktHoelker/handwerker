import UIComponent from 'sap/ui/core/UIComponent';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';
import models from './model/models';

/**
 * @namespace handwerker.components.bpworklist
 */
export default class Component extends UIComponent {
  public static metadata = {
    manifest: 'json'
  };

  public init(): void {
    // call the base component's init function
    super.init();

    const model = this.getModel() as ODataModel;
    // setting a random deferred-group leads to every other request being submitted immediately
    // see https://answers.sap.com/questions/311560/sapui5-odatamodel-setdeferredgroups-autofiring-req.html
    model.setDeferredGroups(['dummy']);

    this.setModel(models.createDeviceModel(), 'device');

    // create the views based on the url/hash
    this.getRouter().initialize();
  }
}
