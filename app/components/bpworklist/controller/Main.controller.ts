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
 * @namespace handwerker.components.bpworklist.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;

  public onInit() {
    this.byId('marginInput')?.bindElement("/Settings('john.doe@web.de')");
  }

  public onPressCreateBP() {
    const bpTable = this.byId('bpTable') as Table;
    const itemsBinding = bpTable?.getBinding('items') as ODataListBinding;
    const newBPContext = itemsBinding.create({});
    const firstItem = bpTable.getItems()[0];

    bpTable.setSelectedItem(firstItem);

    this.byId('detailPage')?.bindElement(newBPContext.getPath());
    this.byId('client_ID')?.focus();
  }

  public onPressDeleteBP(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const model = this.getModel() as ODataModel;
    if (path) {
      model.remove(path);
    }
  }

  public onSearch(event: UI5Event) {
    const query = event.getParameter('query');
    const bpTable = this.byId('bpTable') as Table;

    const bindingInfo = bpTable.getBindingInfo('items') as any;

    if (!bindingInfo.parameters) {
      bindingInfo.parameters = {};
    }
    if (!bindingInfo.parameters.custom) {
      bindingInfo.parameters.custom = {};
    }
    bindingInfo.parameters.custom.search = query;

    bpTable.bindItems(bindingInfo);
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
