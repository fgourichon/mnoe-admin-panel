@App.controller 'SettingsGeneralController', (toastr, CONFIG_JSON_SCHEMA, MnoeTenant) ->
  'ngInject'
  vm = this

  vm.settingsModel = {}
  vm.settingsSchema = CONFIG_JSON_SCHEMA

  vm.settingsForm = [
    {
      type: "tabs"
      tabs: [
        {
          title: "System"
          items: ["system"]
        }
        {
          title: "Dashboard"
          items: ["dashboard"]
        }
        {
          title: "Admin Panel"
          items: ["admin_panel"]
        },
        {
          title: 'Test'
          items: [
            'system.intercom.enabled',
            {
              'type': 'conditional',
              'condition': 'vm.settingsModel.system.intercom.enabled',
              'items': [
                {
                  'key': 'system.intercom.app_id'
                  'destroyStrategy': 'retain'
                }
                {'key': 'system.intercom.api_secret'}
                {'key': 'system.intercom.token'}
              ]
            }
          ]
        }
      ]
    }
  ]

  # Load config from the Tenant
  loadConfig = ->
    MnoeTenant.get().then(
      (response) ->
        vm.settingsModel = response.data.frontend_config
    )

  loadConfig()

  vm.cancel = (form) ->
    vm.settingsModel = {}
    form.$setPristine()
    loadConfig()

  vm.saveSettings = () ->
    vm.isLoading = true
    MnoeTenant.update(vm.settingsModel).then(
      ->
        toastr.success('mnoe_admin_panel.dashboard.settings.save.toastr_success')
      ->
        toastr.error('mnoe_admin_panel.dashboard.settings.save.toastr_error')
    ).finally(-> vm.isLoading = false)

  return