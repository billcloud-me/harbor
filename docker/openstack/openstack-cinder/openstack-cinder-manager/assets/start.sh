#!/bin/bash

# Copyright 2016 Port Direct
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

set -e
echo "${OS_DISTRO}: Launching"
################################################################################
. /etc/os-container.env
. /opt/harbor/service-hosts.sh
. /opt/harbor/harbor-common.sh
. /opt/harbor/cinder/vars.sh


if ! [ $OS_MANAGEMENT_ACTION == "bootstrap" ]; then
  echo "${OS_DISTRO}: Testing service dependancies"
  ################################################################################
  /usr/bin/mysql-test


  echo "${OS_DISTRO}: Config Starting"
  ################################################################################
  /opt/harbor/config-cinder.sh


  echo "${OS_DISTRO}: Managing database"
  ################################################################################
  /opt/harbor/cinder/manage/bootstrap-database.sh


  echo "${OS_DISTRO}: Managing User"
  ################################################################################
  /opt/harbor/cinder/manage/manage-keystone-user.sh


  echo "${OS_DISTRO}: Managing Service"
  ################################################################################
  /opt/harbor/cinder/manage/manage-keystone-service.sh


  echo "${OS_DISTRO}: Finished management"
  ################################################################################
else
  echo "${OS_DISTRO}: Managing Volume types"
  ################################################################################
  /opt/harbor/cinder/bootstrap/bootstrap-volume-types.sh


  echo "${OS_DISTRO}: Managing Volume quotas"
  ################################################################################
  /opt/harbor/cinder/bootstrap/bootstrap-volume-quota.sh


  echo "${OS_DISTRO}: Finished management"
  ################################################################################
  tail -f /dev/null
fi
