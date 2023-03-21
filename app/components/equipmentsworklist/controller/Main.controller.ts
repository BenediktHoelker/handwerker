import BaseController from './BaseController';
import formatter from '../model/formatter';
import List from 'sap/m/List';
import SplitApp from 'sap/m/SplitApp';
import UI5Event from 'sap/ui/base/Event';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';
import ODataListBinding from 'sap/ui/model/odata/v2/ODataListBinding';
import Table from 'sap/m/Table';
import ColumnListItem from 'sap/m/ColumnListItem';
import Button from 'sap/m/Button';
import MessageToast from 'sap/m/MessageToast';
import ResourceBundle from 'sap/base/i18n/ResourceBundle';
import MessageBox from 'sap/m/MessageBox';
import ReuseComponentSupport from 'sap/suite/ui/generic/template/extensionAPI/ReuseComponentSupport';

/**
 * @namespace handwerker.components.equipmentsworklist.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;

  /**
   * onInit
   */
  public onInit() {}

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
