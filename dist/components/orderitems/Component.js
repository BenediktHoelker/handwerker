sap.ui.define(["sap/ui/core/UIComponent", "./model/models"], function (UIComponent, __models) {
  function _interopRequireDefault(obj) {
    return obj && obj.__esModule && typeof obj.default !== "undefined" ? obj.default : obj;
  }
  const models = _interopRequireDefault(__models);
  /**
   * @namespace handwerker.components.orderitems
   */
  const Component = UIComponent.extend("handwerker.components.orderitems.Component", {
    metadata: {
      manifest: 'json'
    },
    init: function _init() {
      // call the base component's init function
      UIComponent.prototype.init.call(this);
      this.setModel(models.createDeviceModel(), 'device');

      // create the views based on the url/hash
      this.getRouter().initialize();
    }
  });
  return Component;
});