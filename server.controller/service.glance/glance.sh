# OpenStack > Controller - Glance

source ./admin-openrc

# Create user glance on keystone
echo 'The glance user password is "GLANCE_PASS"'
openstack user create glance --domain default --password-prompt

# Add  role admin to project service and user glance on keystone
openstack role add admin --project service --user glance

# Create service image on keystone
openstack service create image --name glance --description "OpenStack Image Service"

# Create endpoint public, internal, admin on keystone
openstack endpoint create image --region RegionOne public http://controller:9292
openstack endpoint create image --region RegionOne internal http://controller:9292
openstack endpoint create image --region RegionOne admin http://controller:9292`

# Install glance servic3
apt install -y glance
	 1. 編輯 glance 服務組態檔 `/etc/glance/glance-api.conf`
	 `cp -a /etc/glance/glance-api.conf /etc/glance/glance-api.conf.bk`
		 1. 設定 database 連線方式
```
#1924
[database]
connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
```
		 2. 設定 glance image 儲存方式
```	
# 2041
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images
```
		 4. 設定 glance 支援的 image 格式
```
[image_format]
disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,ploop.root-tar
```
		 5. 設定 keystone 的驗證資訊
```
#3474
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
		 6. 設定 paste_deploy
```
[paste_deploy]
flavor = keystone
```	 

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
