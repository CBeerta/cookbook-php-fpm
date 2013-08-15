#
# Cookbook Name:: php-fpm
# Definition:: fpm_pool
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :fpm_pool, :template => "pool.conf.erb", :enable => true do

  pool_name = params[:name]

  include_recipe "php-fpm"

  conf_file = "#{node['php-fpm']['conf_dir']}/pool.d/#{pool_name}.conf"
  pool_log_dir = "#{node['php-fpm']['pool_log_dir']}/#{pool_name}"
  
  directory pool_log_dir do
    owner node['php-fpm']['pool'][pool_name]['user']
    group node['php-fpm']['pool'][pool_name]['group']
    mode 00755
  end

  template conf_file do
    source params[:template]
    owner "root"
    group "root"
    mode 00644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
    :pool_name => pool_name,
    :listen => node['php-fpm']['pool'][pool_name]['listen'],
    :allowed_clients => node['php-fpm']['pool'][pool_name]['allowed_clients'],
    :user => node['php-fpm']['pool'][pool_name]['user'],
    :group => node['php-fpm']['pool'][pool_name]['group'],
    :process_manager => node['php-fpm']['pool'][pool_name]['process_manager'],
    :max_children => node['php-fpm']['pool'][pool_name]['max_children'],
    :start_servers => node['php-fpm']['pool'][pool_name]['start_servers'],
    :min_spare_servers => node['php-fpm']['pool'][pool_name]['min_spare_servers'],
    :max_spare_servers => node['php-fpm']['pool'][pool_name]['max_spare_servers'],
    :max_requests => node['php-fpm']['pool'][pool_name]['max_requests'],
    :process_idle_timeout => node['php-fpm']['pool'][pool_name]['max_requests'],
    :pool_log_dir => pool_log_dir,
    :params => params
    )
    notifies :reload, "service[php-fpm]", :delayed
  end
end
