# Blur Closed / 关掉模糊效果
A Magisk module to disable blur features / 一个用于禁用模糊特性的 Magisk 模块

## Changelog / 变更日志
### ~~1.3~~
- <s>You can update this module
  in the Magisk / KernelSU / APatch app
  by clicking on the "Update" button if update available
  since this build</s>
  <s>当更新可用时，你可以通过在 Magisk / KernelSU / APatch app中
  点击“更新”按钮对此模块进行更新</s>
- <s>Add action.sh to switch the status of blur temporarily
  (may not work in all ROMs because after resetting the status
  specific props will take effect after reboot
  it is meaningless so only support simple switch so far)</s>
  <s>新增 action.sh 以临时切换模糊状态
  (不会在所有的ROM上起作用，由于某些prop即使重置状态
  也要重启后生效，这没有任何意义，所以仅支持简单的切换)</s>

### 1.2
- Fix a careless problem in the name between "service.sh" and "services.sh" lol
  修复了由于粗心大意把“service.sh”看作“services.sh”的问题
- Add the judgement of Android version to use proper command
  增加 Android 版本判断以使用相应的命令
- Update customize.sh to the newer one
  更新 customize.sh 至新的版本
- Update post-fs-data.sh and add the features of disabling blur in Android 12+ only
  更新 post-fs-data.sh，增加了 Android 12+ 才有的禁用模糊选项
- Update uninstall.sh by syncing the changes in service.sh
  同步更新 uninstall.sh 以还原部分配置至默认选项
- Update module id to lower case to improve the compatibly of specific scenes
  更新模块id为小写字母以提升在部分场合的兼容性

### 1.1
- Initial build / the first page
  第一页
