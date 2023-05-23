import BaseController from '../../../controller/BaseController';
import List from 'sap/m/List';
import SplitApp from 'sap/m/SplitApp';
import UI5Event from 'sap/ui/base/Event';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';
import ODataListBinding from 'sap/ui/model/odata/v2/ODataListBinding';
import Button from 'sap/m/Button';
import MessageToast from 'sap/m/MessageToast';
import ResourceBundle from 'sap/base/i18n/ResourceBundle';
import MessageBox from 'sap/m/MessageBox';
import Page from 'sap/m/Page';
import Binding from 'sap/ui/model/Binding';
import JSONModel from 'sap/ui/model/json/JSONModel';
/**
 * @namespace handwerker.components.businesspartners.controller
 */
export default class Main extends BaseController {
  private _bpList: List;
  private _splitApp: SplitApp;
  private _model: ODataModel;
  private _detailPage: Page;
  private _viewModel: JSONModel;

  public onInit() {
    const router = this.getRouter();

    this._bpList = this.byId('bpList') as List;
    this._splitApp = this.byId('splitApp') as SplitApp;
    this._detailPage = this.byId('detailPage') as Page;

    this._viewModel = new JSONModel({ hasPendingChanges: false });

    this.setModel(this._viewModel, 'viewModel');

    router.getRoute('main')?.attachPatternMatched(() => {
      this._bpList?.getBinding('items')?.attachEventOnce('change', () => {
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
    const listItem = this._bpList.getItems()[index];

    if (!listItem) {
      // @ts-expect-error
      this._splitApp.toDetail(this.byId('notFound'));
      return;
    }

    // @ts-expect-error
    this._splitApp.toDetail(this.byId('main'));

    const path = listItem?.getBindingContext()?.getPath();

    this._bpList.setSelectedItem(listItem);
    this._bindDetailView(path);
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
    this._detailPage.bindElement(path, {
      events: {
        change: this.onDetailViewBindingChange.bind(this)
      }
    });

    // Must be standalone binding => does not work if attached to detailpage-binding
    const context = this._detailPage.getBindingContext();
    const binding = new Binding(this._model, context.getPath(), context);

    binding.attachChange(() => {
      this._viewModel.setProperty(
        '/hasPendingChanges',
        this._model.hasPendingChanges()
      );
    });
  }

  onDetailViewBindingChange() {
    const viewBinding = this.getView().getElementBinding();

    if (!viewBinding.getBoundContext()) {
      // @ts-expect-error
      this._splitApp.toDetail(this.byId('notFound'));
    } else {
      // @ts-expect-error
      this._splitApp.toDetail(this.byId('main'));
    }
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
              const itemToSelect = this._bpList
                .getItems()
                .find(
                  (item) =>
                    item.getBindingContext().getPath() ===
                    this._detailPage.getBindingContext().getPath()
                );

              this._bpList.setSelectedItem(itemToSelect);
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

  public onPressCreateBP() {
    const itemsBinding = this._bpList?.getBinding('items') as ODataListBinding;
    const newBPContext = itemsBinding.create({});
    const firstItem = this._bpList.getItems()[0];
    const detailPage = this._detailPage as Page;

    this._bpList.setSelectedItem(firstItem);

    this._bindDetailView(newBPContext.getPath());
    // @ts-expect-error
    this._splitApp.toDetail(detailPage);
    setTimeout(() => this.byId('name')?.focus());
  }

  public onSearch(event: UI5Event) {
    const query = event.getParameter('query');
    const bindingInfo = this._bpList.getBindingInfo('items') as any;

    if (!bindingInfo.parameters) {
      bindingInfo.parameters = {};
    }
    if (!bindingInfo.parameters.custom) {
      bindingInfo.parameters.custom = {};
    }
    bindingInfo.parameters.custom.search = query;

    this._bpList.bindItems(bindingInfo);
  }

  public async onPressDeleteBP(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const bpListItems = this._bpList.getItems();
    const itemIndex = this._bpList
      .getItems()
      .findIndex((item) => item.getBindingContext().getPath() === path);

    if (path && path.includes('id-')) {
      this._model.resetChanges([path], true, true);
    } else if (path) {
      await new Promise<void>((resolve, reject) => {
        this._model.remove(path, { success: resolve, error: reject });
      });
    }

    if (bpListItems[itemIndex]) {
      this._selectItemAtIndex(itemIndex);
    } else if (bpListItems[itemIndex - 1]) {
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
}
