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

    router.getRoute('main').attachPatternMatched(() => {
      this.byId('masterList')
        .getBinding('items')
        .attachEventOnce('change', (event: UI5Event) => {
          this.onMasterListBindingChange(event);
        });
    });
  }

  public onMasterListBindingChange(event: UI5Event) {
    const masterList = this.byId('masterList') as List;
    const firstMasterListItem = masterList.getItems()[1]; // [0] is a group header
    const path = firstMasterListItem.getBindingContext().getPath();

    masterList.setSelectedItem(firstMasterListItem);
    this.byId('detailPage').bindElement(path);
  }

  public onSelectionChange(event: UI5Event) {
    const { listItem } = event.getParameters();
    if (!listItem.getBindingContext()) return; // Group headers don't have a context

    this.byId('detailPage').bindElement(
      listItem.getBindingContext().getPath(),
      { expand: 'client' }
    );
  }

  public onPressCreateOrderItem() {
    const itemsTable = this.byId('itemsTable') as Table;
    const itemsBinding = itemsTable?.getBinding('items') as ODataListBinding;
    itemsBinding.create({});

    setTimeout(() => {
      const firstItem = itemsTable?.getItems()[0] as ColumnListItem;
      const firstInput = firstItem.getCells()[0];
      firstInput.focus();
    });
  }

  public onPressDeleteItem(event: UI5Event) {
    const item = event.getSource() as Button;
    const path = item.getBindingContext()?.getPath();
    const model = this.getModel() as ODataModel;
    if (path) {
      model.remove(path);
    }
  }

  onPressSubmit() {
    const model = this.getModel() as ODataModel;
    model.submitChanges();
  }

  public onPressToggleMaster() {
    const splitApp = this.byId('splitApp') as SplitApp;

    if (splitApp.isMasterShown()) {
      splitApp.toDetail('detailPage', 'slide', {}, {});
    } else {
      splitApp.toMaster('masterPage', 'slide', {}, {});
    }
  }

  // initNewWorkItem(startDate = roundTimeToQuarterHour(Date.now())) {
  //   const model = this.getModel();
  //   const MyCategoriesNested = model.getProperty('/MyCategoriesNested');

  //   const workItem = {
  //     title: '',
  //     confirmed: true,
  //     date: startDate,
  //     // dateISOString: now,
  //     activatedDate: startDate,
  //     completedDate: addMinutes(startDate, 15)
  //     // activity: model.getData().activities[0],
  //     // location: model.getData().locations[0],
  //   };

  //   model.setProperty('/MyWorkItems/NEW', workItem);
  //   model.setProperty('/MyCategoriesNestedAndFiltered', MyCategoriesNested);

  //   this.byId('hierarchyTree').clearSelection(true);
  // }
}
