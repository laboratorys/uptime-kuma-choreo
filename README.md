# uptime-kuma-choreo

## 说明

1. 在[choreo](https://choreo.dev/)上部署uptime-kuma
2. uptime-kuma基础镜像基于[官方镜像](https://hub.docker.com/r/louislam/uptime-kuma)，仅仅做了以下操作：

- 增加`/app/backup2gh`,用于定时备份数据到GitHub，参考链接：https://github.com/laboratorys/backup-to-github 您需要创建一个仓库用于备份数据

## 部署

1. 注册账号（自行注册，无门槛）， https://choreo.dev/
2. 按照提示创建组织（Organizations）、项目（Project）
3. 创建`Component`，*注意选择*`Create a Web Application`, Repository URL
   填写 https://github.com/laboratorys/uptime-kuma-choreo ，
   `Buildpack` 选择`docker`，`Dockerfile path`做一下选择，端口：`3001`，等待Build完成，大概需要3分钟。
4. （可选）需要备份时，配置环境变量`Devops->Configs & Secrets`
   Secrets，添加备份所需的环境变量，参考：https://github.com/laboratorys/backup-to-github
   ,注意，Secrets是区分环境的，一般我们只需配置Production
5. 配置数据目录：`Devops->Storage`, `Mount Path`填写`/app/data`，Development和Production都配置下，否则部署会报错
6. Deploy: 点击`Configure & Deploy`，部署到`Development`，会得到一个url，正常访问后部署到Production
7. Production会得到一个URL，可以直接使用，也可以缩短自定义前缀，或者绑定域名
8. 添加域名：切换到组织配置，`URL Settings`，添加域名，环境、类型和我们之前创建的组件类型一致，否则无法绑定，本应用我们选择
   `Production`和`Web App`，在域名解析处设置好`CNAME`。
9. 返回`Component->URL Settings`, 绑定我们刚才添加的域名。
10. 组织配置`URL Settings`，对绑定域名的请求审核通过
11. 关闭`Development`, Deploy处点击`Scale to Zero`，选择`No Autoscaling`， `Stop Development`
12. Enjoy it!