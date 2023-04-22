import BaseController from '../../../controller/BaseController';
import formatter from '../model/formatter';
import UI5Event from 'sap/ui/base/Event';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';
import ODataListBinding from 'sap/ui/model/odata/v2/ODataListBinding';
import Table from 'sap/m/Table';
import Button from 'sap/m/Button';
import MessageToast from 'sap/m/MessageToast';
import ResourceBundle from 'sap/base/i18n/ResourceBundle';
import MessageBox from 'sap/m/MessageBox';

/**
 * @namespace handwerker.components.equipmentsworklist.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;

  /**
   * onInit
   */
  public onInit() {
    this.byId('marginInput')?.bindElement("/Settings('john.doe@web.de')");
  }

  public onPressCalculateSalesPrice(event: UI5Event) {
    const model = this.getModel() as ODataModel;
    const margin = this.getModel().getProperty(
      "/Settings('john.doe@web.de')/salesMargin"
    );
    const button = event.getSource() as Button;
    const path = button.getBindingContext()?.getPath();

    const purchasePrice = model.getProperty(path + '/purchasePrice');

    model.setProperty(path + '/margin', margin);
    model.setProperty(
      path + '/salesPrice',
      (Math.round(Number(purchasePrice) * margin * 100) / 100).toFixed(2)
    );
  }

  public onPressCreateEquipment() {
    const equipmentsTable = this.byId('equipmentsTable') as Table;
    const itemsBinding = equipmentsTable?.getBinding(
      'items'
    ) as ODataListBinding;
    const newEquipmentContext = itemsBinding.create({});
    const firstItem = equipmentsTable.getItems()[0];

    equipmentsTable.setSelectedItem(firstItem);

    this.byId('detailPage')?.bindElement(newEquipmentContext.getPath());
    this.byId('client_ID')?.focus();
  }

  public onPressDeleteEquipment(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const model = this.getModel() as ODataModel;
    if (path) {
      model.remove(path);
    }
  }

  public onSearch(event: UI5Event) {
    const query = event.getParameter('query');
    const equipmentsTable = this.byId('equipmentsTable') as Table;

    const bindingInfo = equipmentsTable.getBindingInfo('items') as any;

    if (!bindingInfo.parameters) {
      bindingInfo.parameters = {};
    }
    if (!bindingInfo.parameters.custom) {
      bindingInfo.parameters.custom = {};
    }
    bindingInfo.parameters.custom.search = query;

    equipmentsTable.bindItems(bindingInfo);
  }

  onPressSubmit() {
    const model = this.getModel() as ODataModel;
    const resBundle = this.getResourceBundle() as ResourceBundle;

    model.submitChanges({
      success: () => MessageToast.show(resBundle.getText('submit.successful')),
      error: () => MessageBox.error(resBundle.getText('submit.error'))
    });
  }
}
