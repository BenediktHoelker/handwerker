import BaseController from './BaseController';
import formatter from '../this._model/formatter';
import List from 'sap/m/List';
import SplitApp from 'sap/m/SplitApp';
import UI5Event from 'sap/ui/base/Event';
import ODataModel from 'sap/ui/this._model/odata/v2/ODataModel';
import ODataListBinding from 'sap/ui/this._model/odata/v2/ODataListBinding';
import Table from 'sap/m/Table';
import ColumnListItem from 'sap/m/ColumnListItem';
import Button from 'sap/m/Button';
import MessageToast from 'sap/m/MessageToast';
import ResourceBundle from 'sap/base/i18n/ResourceBundle';
import MessageBox from 'sap/m/MessageBox';
import ReuseComponentSupport from 'sap/suite/ui/generic/template/extensionAPI/ReuseComponentSupport';
import Input from 'sap/m/Input';
import Tab from 'sap/ui/webc/main/Tab';
import Page from 'sap/m/Page';
import Splitter from 'sap/ui/layout/Splitter';
import Fragment from 'sap/ui/core/Fragment'; //by importing
import jsPDFInvoiceTemplate, { OutputType } from 'jspdf-invoice-template';

/**
 * @namespace handwerker.components.orders.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;
  private _ordersList: List;
  private _splitApp: SplitApp;
  private _model: ODataModel;
  private _detailPage: Page;
  private _orderItemsTable: Table;
  /**
   * onInit
   */
  public onInit() {
    const router = this.getRouter();

    this._ordersList = this.byId('ordersList') as List;
    this._orderItemsTable = this.byId('this._orderItemsTable') as Table;
    this._splitApp = this.byId('splitApp') as SplitApp;
    this._model = this.getModel() as ODataModel;
    this._detailPage = this._detailPage as Page;

    router.getRoute('main')?.attachPatternMatched(() => {
      this.byId('this._ordersList')
        ?.getBinding('items')
        ?.attachEventOnce('change', () => {
          this._selectFirstItem();
        });
    });
  }

  private _selectFirstItem() {
    this._selectItemAtIndex(0);
  }

  private _selectItemAtIndex(index: int) {
    const firstOrdersListItem = this._ordersList.getItems()[index]; // [0] is a group header
    const path = firstOrdersListItem?.getBindingContext()?.getPath();

    this._ordersList.setSelectedItem(firstOrdersListItem);
    if (path) {
      this._detailPage?.bindElement(path);
    }
  }

  public async onSelectionChange(event: UI5Event) {
    const { listItem } = event.getParameters();

    if (!listItem.getBindingContext()) return; // Group headers don't have a context

    this._detailPage?.bindElement(listItem.getBindingContext().getPath());

    this.checkForPendingChanges().then(() => {
      // @ts-expect-error
      this._splitApp.toDetail(this._detailPage, 'slide', {}, {});
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
            } else reject();
          }
        });
      });
    }
  }

  public showMaster() {
    this.checkForPendingChanges().then(() => {
      this._splitApp.backMaster({}, {});
    });
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
      const totalItemPrice = (
        Math.round(
          Number(orderItem.quantity) * Number(orderItem.unitSalesPrice) * 100
        ) / 100
      )
        .toFixed(2)
        .toString();

      this._model.setProperty(path + '/salesPrice', totalItemPrice);
      this._model.setProperty(
        path + '/salesPriceCurrency_code',
        orderItem.unitSalesPriceCurrency_code
      );

      const orderPath = this._detailPage.getBindingContext().getPath();
      const orderItemsTable = this.byId('this._orderItemsTable') as Table;

      const totalPrice = orderItemsTable
        .getItems()
        .map((item) => item.getBindingContext().getProperty('salesPrice'))
        .map((price) => Number(price))
        .filter((price) => !!price && !isNaN(price))
        .reduce((acc, curr) => acc + Number(curr), 0);

      // TODO: refactor rounding (put to its own method etc.)
      this._model.setProperty(
        orderPath + '/salesPrice',
        (Math.round(totalPrice * 100) / 100).toFixed(2).toString()
      );
      // TODO: implement currency-handling
      this._model.setProperty(orderPath + '/salesPriceCurrency_code', 'EUR');
    });
  }

  public onPressCreateOrder() {
    const itemsBinding = this._ordersList?.getBinding(
      'items'
    ) as ODataListBinding;
    const newOrderContext = itemsBinding.create({});
    const firstItem = this._ordersList.getItems()[0];
    const detailPage = this._detailPage as Page;

    this._ordersList.setSelectedItem(firstItem);

    detailPage?.bindElement(newOrderContext.getPath());
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

  public onPressDeleteItem(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();

    // TODO: make it async => wait for it to calculateSalesPrice correctly
    if (path) {
      this._model.remove(path);
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

    // TODO: make it async => wait for it to calculateSalesPrice correctly
    if (path) {
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

  public onPressPrint() {
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
        src: 'https://raw.githubusercontent.com/edisonneza/jspdf-invoice-template/demo/images/logo.png',
        type: 'PNG', //optional, when src= data:uri (nodejs case)
        width: 53.33, //aspect ratio = width/height
        height: 26.66,
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
        name: 'Business Name',
        address: 'Albania, Tirane ish-Dogana, Durres 2001',
        phone: '(+355) 069 11 11 111',
        email: 'email@example.com',
        email_1: 'info@example.al',
        website: 'www.example.al'
      },
      contact: {
        label: 'Invoice issued for:',
        name: 'Client Name',
        address: 'Albania, Tirane, Astir',
        phone: '(+355) 069 22 22 222',
        email: 'client@website.al',
        otherInfo: 'www.website.al'
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
  }
}
