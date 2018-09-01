# Controller - Glance

source ./admin-openrc

# Install glance service
apt install -y glance

# Backup the origin file
if [ -f "/etc/keystone/keystone.conf" ]
then
	echo "The backup keystone conf exist, do not thing."
else
	echo "Backup the keystone conf file."
	cp -a /etc/glance/glance-api.conf /etc/glance/glance-api.conf.bk
	cp -af glance-api.conf /etc/glance/glance-api.conf
fi


:'
1. Setting the connection for database
# 1924
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance

2. Setting the store method for glance image
# 2041
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images

3. Setting the support image format for glance
# 3459
[image_format]
disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.root-tar

4. Setting the authentication information for keystone
# 3474 <-- Insert these configuration after this line
[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS

5. Setting the paste_deploy
# 4489
[paste_deploy]
flavor = keystone
'
break

	2. 編輯 glance 註冊組態檔 `/etc/glance/glance-registry.conf`
	`cp -a /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.bk`
		 1. 設定 database 連線方式
```
#1170
[database] 
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```
		 2. 設定 keystone 的驗證資訊
```
#1287
[keystone_authtoken]
#於此行後插入以下組態
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = GLANCE_PASS
```
		 3. 設定 paste_deploy
```
[paste_deploy]
flavor = keystone
```

	 3. 使用 glance-manage 對資料庫做同步化 (建立資料表、欄位、基礎資料…等)
	`glance-manage db_sync`
	4. 重新啟動 glance 註冊服務
	`systemctl restart glance-registry.service`
	5. 重新啟動 glance 服務
	`systemctl restart glance-api.service`

 6. 上傳 image 到 glance server  (Controller)
`wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img`
```
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
```
 `openstack image list`
