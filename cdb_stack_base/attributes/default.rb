# cdb base attributes

default['cdb_base']['is_wip']         = true

# directories
default['cdb_base']['localdir']['base']   = "/opt/apps/ms"
default['cdb_base']['localdir']['java']   = "#{node['cdb_base']['localdir']['base']}/java"
default['cdb_base']['localdir']['tomcat'] = "#{node['cdb_base']['localdir']['base']}/tomcat"
default['cdb_base']['localdir']['mysql']  = "#{node['cdb_base']['localdir']['base']}/mysql"
default['cdb_base']['localdir']['logs']   = "#{node['cdb_base']['localdir']['base']}/logs"
default['cdb_base']['localdir']['config'] = "#{node['cdb_base']['localdir']['base']}/config"
default['cdb_base']['localdir']['init']   = "#{node['cdb_base']['localdir']['base']}/init.d"
default['cdb_base']['localdir']['tmp']    = "#{node['cdb_base']['localdir']['base']}/tmp"

#cdb apps
default['cdb_base']['localdir']['cdbapps'] = "#{node['cdb_base']['localdir']['base']}/cdbapps"
default['cdb_base']['localdir']['LD_LIB_PATH'] = "#{node['cdb_base']['localdir']['base']}/gs_libs"
default['cdb_base']['localdir']['tmp_pod'] = "#{node['cdb_base']['localdir']['base']}/tmp/pod"
default['cdb_base']['localdir']['tmp_block'] = "#{node['cdb_base']['localdir']['base']}/tmp/block"
default['cdb_base']['localdir']['tmp_meta'] =   "#{node['cdb_base']['localdir']['base']}/tmp/meta"
default['cdb_base']['localdir']['storedir'] =   "#{node['cdb_base']['localdir']['base']}/storedir"
default['cdb_base']['localdir']['cdb_storage'] =   "#{node['cdb_base']['localdir']['base']}/cdb_storage"


# for email reports
default['cdb_base']['report']['from_address'] = "root@#{node['ipaddress']}"
default['cdb_base']['report']['to_address'] = "pcjoshi9@gmail.com"

# global user for cdb. Anywhere things were to be owned by "root" in a generic way, it's specified as
# root.
default['cdb_base']['appuser']['username'] = "root"
default['cdb_base']['appuser']['group'] = "root"

default['cdb_base']['file_repo']['hostname'] = "http://10.0.0.8:80"
default['cdb_base']['file_repo']['directory'] = "cdb_test/install"

# global java attributes
default['cdb_base']['java']['install_flavor'] = "oracle"
default['cdb_base']['java']['jdk_version'] = "6.017"

