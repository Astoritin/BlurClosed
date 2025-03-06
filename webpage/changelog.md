# Blur Closed / 关掉模糊效果
A Magisk module to disable blur features / 一个用于禁用模糊特性的 Magisk 模块

## Changelog / 变更日志

## 1.1.0

- Support adding additional props for Xiaomi/Redmi devices
- 支持针对小米设备额外添加属性值
- Support adding additional props for Android 11 and higher devices
- 支持针对 Android 11 及更高版本额外添加属性值
- Sync the utilities partially to enhance the new features
- 同步部分实用组件以增强新功能
- Enhance integrity checks for module itself
- 同步为该模块启用完整性验证

## 1.0.1
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
- Add new props: ro.surface_flinger.force_disable_blur=1
  增加新属性参数：ro.surface_flinger.force_disable_blur=1

## 1.0
- Initial build / the first page
  第一页
