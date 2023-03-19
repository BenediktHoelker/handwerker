sap.ui.define(["./BaseController", "../model/formatter"], function (__BaseController, __formatter) {
  function _interopRequireDefault(obj) {
    return obj && obj.__esModule && typeof obj.default !== "undefined" ? obj.default : obj;
  }
  const BaseController = _interopRequireDefault(__BaseController);
  const formatter = _interopRequireDefault(__formatter);
  /**
   * @namespace handwerker.components.orderitems.controller
   */
  const Main = BaseController.extend("handwerker.components.orderitems.controller.Main", {
    constructor: function constructor() {
      BaseController.prototype.constructor.apply(this, arguments);
      this.formatter = formatter;
    },
    onInit: function _onInit() {
      const router = this.getRouter();
      router.getRoute('main').attachPatternMatched(() => {
        this.byId('masterList').getBinding('items').attachEventOnce('change', event => {
          this.onMasterListBindingChange(event);
        });
      });
    },
    onMasterListBindingChange: function _onMasterListBindingChange(event) {
      const masterList = this.byId('masterList');
      const firstMasterListItem = masterList.getItems()[0];
      const path = firstMasterListItem.getBindingContext().getPath();
      this.byId('detailPage').bindElement(path);
    },
    onSelectionChange: function _onSelectionChange(event) {
      const {
        listItem
      } = event.getParameters();
      if (!listItem.getBindingContext()) return; // Group headers don't have a context

      this.byId('detailPage').bindElement(listItem.getBindingContext().getPath(), {
        expand: 'equipment'
      });
    },
    onPressSubmit: function _onPressSubmit() {
      const model = this.getModel();
      model.submitChanges();
    },
    onPressToggleMaster: function _onPressToggleMaster() {
      const splitApp = this.byId('splitApp');
      if (splitApp.isMasterShown()) {
        splitApp.toDetail('detailPage', 'slide', {}, {});
      } else {
        splitApp.toMaster('masterPage', 'slide', {}, {});
      }
    }
  });
  return Main;
});