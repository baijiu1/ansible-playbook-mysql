# ansible-playbook-mysql
## mysql自动化安装脚本
需要你提前把rpm包打好
### 关键字说明：
1）business_name：业务名称，用于修改主机的hostname，复制是通过hostname来识别主机的。
2）mysql_roles：要部署的模式。有三种：replica、test、mgr。
### 对应目录说明：
1、replica：自动安装mysql主从复制的剧本，只需传入"mysql_roles=replica business_name=你的业务名称",修改site.yaml文件中的hosts字段即可开始部署。hosts字段可以填写多个主机，该剧本只会选取其中一台主机当做主库，其余都是从库。该rpm是经过优化之后的mysql，适合于部署在生产环境中。
如果只传入一个主机，那么会自动部署master的rpm包。
2、test：适合部署在测试环境中，同样必须要传入"mysql_roles=test business_name=你的业务名称"
3、mgr：顾名思义，安装mysql MGR模式，默认为单主模式。

hosts文件需要修改为你自己的主机，也可以使用动态主机传入

使用方法：
ansible-playbook -i ./hosts site.yaml -e "mysql_roles=replica business_name=your_business_name"
