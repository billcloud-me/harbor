#!/bin/bash

# Copyright 2016 Port Direct
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
echo "${OS_DISTRO}: Cinder Config Starting"
################################################################################
. /etc/os-container.env
. /opt/harbor/service-hosts.sh
. /opt/harbor/harbor-common.sh
. /opt/harbor/murano/vars.sh


################################################################################
check_required_vars MURANO_CONFIG_FILE \
                    OS_DOMAIN


################################################################################
mkdir -p /etc/murano


echo "${OS_DISTRO}: Starting logging config"
################################################################################
/opt/harbor/murano/config-logging.sh


echo "${OS_DISTRO}: Starting database config"
################################################################################
/opt/harbor/murano/config-database.sh


echo "${OS_DISTRO}: Starting messaging config"
################################################################################
/opt/harbor/murano/config-messaging.sh


echo "${OS_DISTRO}: Starting keystone config"
################################################################################
/opt/harbor/murano/config-keystone.sh
