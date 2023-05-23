import BaseController from '../../../controller/BaseController';
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
import Input from 'sap/m/Input';
import Page from 'sap/m/Page';
import jsPDFInvoiceTemplate, { OutputType } from 'jspdf-invoice-template';
import Binding from 'sap/ui/model/Binding';
import View from 'sap/ui/vk/View';
import JSONModel from 'sap/ui/model/json/JSONModel';
import Dialog from 'sap/m/Dialog';
import UploadSet from 'sap/m/upload/UploadSet';
import UploaderHttpRequestMethod from 'sap/m/upload/UploaderHttpRequestMethod';
import { Addresses, BusinessPartners, Orders } from '../../../metadata';

/**
 * @namespace handwerker.components.orders.controller
 */
export default class Main extends BaseController {
  private _ordersList: List;
  private _splitApp: SplitApp;
  private _model: ODataModel;
  private _detailPage: Page;
  private _orderItemsTable: Table;
  private _viewModel: JSONModel;

  public onInit() {
    const router = this.getRouter();

    this._ordersList = this.byId('ordersList') as List;
    this._orderItemsTable = this.byId('itemsTable') as Table;
    this._splitApp = this.byId('splitApp') as SplitApp;
    this._detailPage = this.byId('detailPage') as Page;

    this._viewModel = new JSONModel({ hasPendingChanges: false });

    this.setModel(this._viewModel, 'viewModel');

    router.getRoute('main')?.attachPatternMatched(() => {
      this._ordersList?.getBinding('items')?.attachEventOnce('change', () => {
        this._selectFirstItem();
      });
    });
  }

  public onAfterRendering() {
    this._model = this.getModel() as ODataModel;
  }

  private _selectFirstItem() {
    this._selectItemAtIndex(0);
  }

  private _selectItemAtIndex(index: int) {
    const firstOrdersListItem = this._ordersList.getItems()[index]; // [0] is a group header
    const path = firstOrdersListItem?.getBindingContext()?.getPath();

    this._ordersList.setSelectedItem(firstOrdersListItem);

    if (path) {
      this._bindDetailView(path);
    }
  }

  public async onSelectionChange(event: UI5Event) {
    const { listItem } = event.getParameters();

    if (!listItem.getBindingContext()) return; // Group headers don't have a context

    await this.checkForPendingChanges();

    this._bindDetailView(listItem.getBindingContext().getPath());
    // @ts-expect-error
    this._splitApp.toDetail(this._detailPage);
  }

  private _bindDetailView(path: string) {
    this._detailPage?.bindElement(path);

    const context = this._detailPage.getBindingContext();
    const binding = new Binding(this._model, context.getPath(), context);

    binding.attachChange(() => {
      this._viewModel.setProperty(
        '/hasPendingChanges',
        this._model.hasPendingChanges()
      );
    });
  }

  public async checkForPendingChanges() {
    const resBundle = this.getResourceBundle() as ResourceBundle;
    if (this._model.hasPendingChanges()) {
      await new Promise<void>((resolve, reject) => {
        MessageBox.confirm(resBundle.getText('confirm.resetChanges'), {
          onClose: (action: String) => {
            if (action === 'OK') {
              this._model.resetChanges(undefined, true, true);

              resolve();
            } else {
              const itemToSelect = this._ordersList
                .getItems()
                .find(
                  (item) =>
                    item.getBindingContext().getPath() ===
                    this._detailPage.getBindingContext().getPath()
                );

              this._ordersList.setSelectedItem(itemToSelect);
              itemToSelect.focus();

              reject();
            }
          }
        });
      });
    }
  }

  public async showMaster() {
    await this.checkForPendingChanges();
    this._splitApp.backMaster({}, {});
  }

  public calculateSalesPrice(event: UI5Event) {
    const control = event.getSource() as Input;
    const path = control.getBindingContext()?.getPath();

    setTimeout(() => {
      const orderItem = control.getBindingContext()?.getObject() as {
        quantity: String;
        unitSalesPrice: String;
        unitSalesPriceCurrency_code: String;
      };
      const totalItemPriceRaw =
        Number(orderItem.quantity) * Number(orderItem.unitSalesPrice);
      const totalItemPrice = this._roundTo2Digits(totalItemPriceRaw);

      this._model.setProperty(path + '/salesPrice', totalItemPrice);
      this._model.setProperty(
        path + '/salesPriceCurrency_code',
        orderItem.unitSalesPriceCurrency_code
      );

      const orderPath = this._detailPage.getBindingContext().getPath();

      const totalPrice = this._orderItemsTable
        .getItems()
        .map((item) => item.getBindingContext().getProperty('salesPrice'))
        .map((price) => Number(price))
        .filter((price) => !!price && !isNaN(price))
        .reduce((acc, curr) => acc + Number(curr), 0);

      this._model.setProperty(
        orderPath + '/salesPrice',
        this._roundTo2Digits(totalPrice)
      );
      // TODO: implement currency-handling
      this._model.setProperty(orderPath + '/salesPriceCurrency_code', 'EUR');
    });
  }

  private _roundTo2Digits(raw: any) {
    const rawNumber = Number(raw);
    const rounded = (Math.round(rawNumber * 100) / 100).toFixed(2).toString();
    // The backend returns 1.5 when the frontend has 1.50 => this is interpreted as pendingChanges by the v2-ODataModel
    const removePadding = parseFloat(rounded).toString();
    return removePadding;
  }

  public onPressOpenFilesDialog() {
    const fileUploadDialog = this.byId('fileUploadDialog') as Dialog;
    fileUploadDialog.open();
  }

  public async onAfterItemAdded(event: UI5Event) {
    const item = event.getParameter('item');
    const { ID } = await this._createAttachment(item);

    this._uploadContent(item, ID);
  }

  public onUploadCompleted(oEvent: UI5Event) {
    const uploadSet = this.byId('uploadSet') as UploadSet;
    uploadSet.removeAllIncompleteItems();
  }

  private async _createAttachment(item: any): Promise<{
    ID: string;
  }> {
    const order_ID = this._detailPage.getBindingContext().getProperty('ID');

    return new Promise((resolve, reject) =>
      this._model.create(
        '/Attachments',
        {
          order_ID,
          createdAt: new Date(),
          mediaType: item.getMediaType(),
          fileName: item.getFileName(),
          size: item.getFileObject().size
        },
        {
          success: resolve,
          error: reject
        }
      )
    );
  }

  private _uploadContent(item: any, ID: string) {
    const url = `/v2/handwerker/Attachments(${ID})/content`;
    const uploadSet = this.byId('uploadSet') as UploadSet;

    item.setUploadUrl(url);

    uploadSet.setHttpRequestMethod(UploaderHttpRequestMethod.Put);
    uploadSet.uploadItem(item);
  }

  public onPressCreateOrder() {
    const itemsBinding = this._ordersList?.getBinding(
      'items'
    ) as ODataListBinding;
    const newOrderContext = itemsBinding.create({});
    const firstItem = this._ordersList.getItems()[0];
    const detailPage = this._detailPage as Page;

    this._ordersList.setSelectedItem(firstItem);

    this._bindDetailView(newOrderContext.getPath());
    // @ts-expect-error
    this._splitApp.toDetail(detailPage);
    this.byId('title')?.focus();
  }

  public onPressCreateOrderItem(event: UI5Event) {
    const itemsBinding = this._orderItemsTable?.getBinding('items') as any;

    itemsBinding.create({ quantity: 1 });

    setTimeout(() => {
      const firstItem = this._orderItemsTable?.getItems()[0] as ColumnListItem;
      const firstInput = firstItem.getCells()[0];
      firstInput.focus();
    }, 30);
  }

  public async onPressDeleteItem(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();

    if (path && path.includes('id')) {
      this._model.resetChanges([path], true, true);
    } else if (path) {
      await new Promise<void>((resolve, reject) => {
        this._model.remove(path, { success: resolve, error: reject });
      });
    }

    this.calculateSalesPrice(event);
  }

  public onSearch(event: UI5Event) {
    const query = event.getParameter('query');
    const bindingInfo = this._ordersList.getBindingInfo('items') as any;

    if (!bindingInfo.parameters) {
      bindingInfo.parameters = {};
    }
    if (!bindingInfo.parameters.custom) {
      bindingInfo.parameters.custom = {};
    }
    bindingInfo.parameters.custom.search = query;

    this._ordersList.bindItems(bindingInfo);
  }

  public async onPressDeleteOrder(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const ordersListItems = this._ordersList.getItems();
    const itemIndex = this._ordersList
      .getItems()
      .findIndex((item) => item.getBindingContext().getPath() === path);

    if (path && path.includes('id')) {
      this._model.resetChanges([path], true, true);
    } else if (path) {
      await new Promise<void>((resolve, reject) => {
        this._model.remove(path, { success: resolve, error: reject });
      });
    }

    if (ordersListItems[itemIndex]) {
      this._selectItemAtIndex(itemIndex);
    } else if (ordersListItems[itemIndex - 1]) {
      this._selectItemAtIndex(itemIndex - 1);
    }
  }

  onPressSubmit() {
    const resBundle = this.getResourceBundle() as ResourceBundle;

    this._model.submitChanges({
      success: () =>
        MessageToast.show(resBundle.getText('submit.successful'), {
          of: this._detailPage,
          offset: '0 -80'
        }),
      error: () => MessageBox.error(resBundle.getText('submit.error'))
    });
  }

  public async onPressPrint() {
    const appVM = this.getModel('appVM');
    const user = appVM.getProperty('/user');
    const order = this._detailPage.getBindingContext().getObject() as Orders;

    try {
      const [mySettings, client] = await Promise.all([
        new Promise<Addresses>((resolve, reject) =>
          this._model.read(
            this._model.createKey('/Settings', { userEmail: user }),
            { success: resolve, error: reject }
          )
        ),
        new Promise<BusinessPartners>((resolve, reject) =>
          this._model.read(
            this._model.createKey('/BusinessPartners', {
              ID: order.client_ID
            }),
            {
              success: resolve,
              error: reject
            }
          )
        )
      ]);

      const items = this._orderItemsTable
        .getItems()
        .map((item) => item.getBindingContext().getObject());

      const propsObject = {
        outputType: OutputType.Save,
        returnJsPDFDocObject: true,
        fileName: 'Invoice 2021',
        orientationLandscape: false,
        compress: true,
        logo: {
          src: sap.ui.require.toUrl('handwerker/images/iot_logo_512.png'),
          type: 'PNG', //optional, when src= data:uri (nodejs case)
          width: 15, //aspect ratio = width/height
          height: 15,
          margin: {
            top: 0, //negative or positive num, from the current position
            left: 0 //negative or positive num, from the current position
          }
        },
        stamp: {
          inAllPages: true, //by default = false, just in the last page
          src: 'https://raw.githubusercontent.com/edisonneza/jspdf-invoice-template/demo/images/qr_code.jpg',
          type: 'JPG', //optional, when src= data:uri (nodejs case)
          width: 20, //aspect ratio = width/height
          height: 20,
          margin: {
            top: 0, //negative or positive num, from the current position
            left: 0 //negative or positive num, from the current position
          }
        },
        business: {
          name: mySettings.address_email,
          address: mySettings.address_street,
          phone: mySettings.address_phone,
          email: mySettings.address_email,
          website: mySettings.address_website
        },
        contact: {
          label: 'Invoice issued for:',
          name: client.name,
          address: client.address_street,
          phone: client.address_phone,
          email: client.address_email,
          otherInfo: client.address_6website
        },
        invoice: {
          label: 'Invoice #: ',
          num: 19,
          invDate: 'Payment Date: 01/01/2021 18:12',
          invGenDate: 'Invoice Date: 02/02/2021 10:17',
          headerBorder: false,
          tableBodyBorder: false,
          header: [
            {
              title: '#',
              style: {
                width: 10
              }
            },
            {
              title: 'Equipment',
              style: {
                width: 80
              }
            },
            {
              title: 'Quantity',
              style: {
                width: 30
              }
            },
            { title: 'Unit Price' },
            { title: 'Sales Price' }
          ],
          table: items.map((item: any, index: int) => [
            index,
            item.equipmentName,
            item.quantity,
            item.unitSalesPrice + ' ' + item.unitSalesPriceCurrency_code,
            item.salesPrice + ' ' + item.salesPriceCurrency_code
          ]),
          // table: Array.from(Array(10), (item, index) => [
          //   index + 1,
          //   'There are many variations ',
          //   'Lorem Ipsum is simply dummy text dummy text ',
          //   200.5,
          //   4.5,
          //   'm2',
          //   400.5
          // ]),
          additionalRows: [
            {
              col1: 'Total:',
              col2: '145,250.50',
              col3: 'ALL',
              style: {
                fontSize: 14 //optional, default 12
              }
            },
            {
              col1: 'VAT:',
              col2: '20',
              col3: '%',
              style: {
                fontSize: 10 //optional, default 12
              }
            },
            {
              col1: 'SubTotal:',
              col2: '116,199.90',
              col3: 'ALL',
              style: {
                fontSize: 10 //optional, default 12
              }
            }
          ],
          invDescLabel: 'Invoice Note',
          invDesc:
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary."
        },
        footer: {
          text: 'The invoice is created on a computer and is valid without the signature and stamp.'
        },
        pageEnable: true,
        pageLabel: 'Page '
      };

      // @ts-expect-error
      jsPDFInvoiceTemplate(propsObject);
    } catch (error) {
      // errorhandler
    }
  }
}
