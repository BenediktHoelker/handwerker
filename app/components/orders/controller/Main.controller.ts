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
 * @namespace handwerker.components.orders.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;

  /**
   * onInit
   */
  public onInit() {
    const router = this.getRouter();

    router.getRoute('main')?.attachPatternMatched(() => {
      this.byId('ordersList')
        ?.getBinding('items')
        ?.attachEventOnce('change', (event: UI5Event) => {
          this._selectFirstItem(event);
        });
    });
  }

  private _selectFirstItem(event: UI5Event) {
    const ordersList = this.byId('ordersList') as List;
    const firstMasterListItem = ordersList.getItems()[1]; // [0] is a group header
    const path = firstMasterListItem?.getBindingContext()?.getPath();

    ordersList.setSelectedItem(firstMasterListItem);
    if (path) {
      this.byId('detailPage')?.bindElement(path);
    }
  }

  public onSelectionChange(event: UI5Event) {
    const { listItem } = event.getParameters();
    if (!listItem.getBindingContext()) return; // Group headers don't have a context

    this.byId('detailPage')?.bindElement(
      listItem.getBindingContext().getPath()
    );
  }

  public onPressCreateOrder() {
    const ordersList = this.byId('ordersList') as List;
    const itemsBinding = ordersList?.getBinding('items') as ODataListBinding;
    const newOrderContext = itemsBinding.create({});
    const firstItem = ordersList.getItems()[0];

    ordersList.setSelectedItem(firstItem);

    this.byId('detailPage')?.bindElement(newOrderContext.getPath());
    this.byId('client_ID')?.focus();
  }

  public onPressCreateOrderItem() {
    const itemsTable = this.byId('itemsTable') as Table;
    const itemsBinding = itemsTable?.getBinding('items') as ODataListBinding;

    itemsBinding.create({});

    setTimeout(() => {
      const firstItem = itemsTable?.getItems()[0] as ColumnListItem;
      const firstInput = firstItem.getCells()[0];
      firstInput.focus();
    }, 30);
  }

  public onPressDeleteItem(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const model = this.getModel() as ODataModel;
    if (path) {
      model.remove(path);
    }
  }

  public onSearch(event: UI5Event) {
    const query = event.getParameter('query');
    const ordersList = this.byId('ordersList') as List;

    const bindingInfo = ordersList.getBindingInfo('items') as any;

    if (!bindingInfo.parameters) {
      bindingInfo.parameters = {};
    }
    if (!bindingInfo.parameters.custom) {
      bindingInfo.parameters.custom = {};
    }
    bindingInfo.parameters.custom.search = query;

    ordersList.bindItems(bindingInfo);
  }

  onPressSubmit() {
    const model = this.getModel() as ODataModel;
    const resBundle = this.getResourceBundle() as ResourceBundle;

    model.submitChanges({
      success: () => MessageToast.show(resBundle.getText('submit.successful')),
      error: () => MessageBox.error(resBundle.getText('submit.error'))
    });
  }

  public onPressToggleMaster() {
    const splitApp = this.byId('splitApp') as SplitApp;

    if (splitApp.isMasterShown()) {
      splitApp.toDetail('detailPage', 'slide', {}, {});
    } else {
      splitApp.toMaster('masterPage', 'slide', {}, {});
    }
  }
}
