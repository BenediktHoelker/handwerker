import BaseController from '../../../controller/BaseController';
import formatter from '../model/formatter';
import ODataModel from 'sap/ui/model/odata/v2/ODataModel';
import MessageToast from 'sap/m/MessageToast';
import ResourceBundle from 'sap/base/i18n/ResourceBundle';
import MessageBox from 'sap/m/MessageBox';
import { Users } from '../../../metadata';
import JSONModel from 'sap/ui/model/json/JSONModel';
import Binding from 'sap/ui/model/Binding';
import Context from 'sap/ui/model/Context';

/**
 * @namespace handwerker.components.settings.controller
 */
export default class Main extends BaseController {
  private formatter = formatter;

  private _viewModel: JSONModel;

  public onInit(): void {
    this._viewModel = new JSONModel({ hasPendingChanges: false });
    this.setModel(this._viewModel, 'viewModel');
  }

  public onBeforeRendering() {
    const model = this.getModel() as ODataModel;
    const view = this.getView();

    model.callFunction('/getUserInfo', {
      success: (user: Users) => {
        const path = model.createKey('/Settings', { userEmail: user.email });
        const context = new Context(model, path);
        const binding = new Binding(model, context.getPath(), context);

        binding.attachChange(() => {
          this._viewModel.setProperty(
            '/hasPendingChanges',
            model.hasPendingChanges()
          );
        });

        view.bindElement(path, { expand: 'address' });
      }
    });
  }

  onPressSubmit() {
    const model = this.getModel() as ODataModel;
    const resBundle = this.getResourceBundle() as ResourceBundle;

    model.submitChanges({
      success: () => {
        MessageToast.show(resBundle.getText('submit.successful'));
        this._viewModel.setProperty('/hasPendingChanges', false);
      },
      error: () => MessageBox.error(resBundle.getText('submit.error'))
    });
  }
}
