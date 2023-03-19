import BaseController from './BaseController';
import formatter from '../model/formatter';
import List from 'sap/m/List';
import SplitApp from 'sap/m/SplitApp';
import UI5Event from 'sap/ui/base/Event';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';

/**
 * @namespace handwerker.components.orderitems.controller
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
    const firstMasterListItem = masterList.getItems()[0];
    const path = firstMasterListItem.getBindingContext().getPath();

    this.byId('detailPage').bindElement(path);
  }

  public onSelectionChange(event: UI5Event) {
    const { listItem } = event.getParameters();
    if (!listItem.getBindingContext()) return; // Group headers don't have a context

    this.byId('detailPage').bindElement(
      listItem.getBindingContext().getPath(),
      { expand: 'equipment' }
    );
  }

  onPressSubmit() {
    const model = this.getModel() as ODataModel;
    model.submitChanges();
  }

  public onPressToggleMaster() {
    const splitApp = this.byId('splitApp') as SplitApp;

    if (splitApp.isMasterShown()) {
      splitApp.toDetail(this.byId('detailPage'));
    } else {
      splitApp.toMaster(this.byId('masterPage'));
    }
  }

  initNewWorkItem(startDate = roundTimeToQuarterHour(Date.now())) {
    const model = this.getModel();
    const MyCategoriesNested = model.getProperty('/MyCategoriesNested');

    const workItem = {
      title: '',
      confirmed: true,
      date: startDate,
      // dateISOString: now,
      activatedDate: startDate,
      completedDate: addMinutes(startDate, 15)
      // activity: model.getData().activities[0],
      // location: model.getData().locations[0],
    };

    model.setProperty('/MyWorkItems/NEW', workItem);
    model.setProperty('/MyCategoriesNestedAndFiltered', MyCategoriesNested);

    this.byId('hierarchyTree').clearSelection(true);
  }
}
