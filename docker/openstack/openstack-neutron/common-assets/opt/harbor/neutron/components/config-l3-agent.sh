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
echo "${OS_DISTRO}: Configuring Neutron L3 Agent"
################################################################################
. /etc/os-container.env
. /opt/harbor/service-hosts.sh
. /opt/harbor/harbor-common.sh
. /opt/harbor/neutron/vars.sh


################################################################################
check_required_vars NEUTRON_METADATA_CONFIG_FILE \
                    NEUTRON_L3_CONFIG_FILE \
                    OS_DOMAIN


################################################################################
crudini --set ${NEUTRON_L3_CONFIG_FILE} DEFAULT l3_agent_manager "neutron.agent.l3_agent.L3NATAgentWithStateReport"


crudini --set ${NEUTRON_L3_CONFIG_FILE} DEFAULT interface_driver "openvswitch"
crudini --set ${NEUTRON_L3_CONFIG_FILE} DEFAULT ovs_use_veth "False"
crudini --set ${NEUTRON_L3_CONFIG_FILE} DEFAULT external_network_bridge "br-ex"

crudini --set ${NEUTRON_L3_CONFIG_FILE} AGENT root_helper_daemon "sudo /usr/bin/neutron-rootwrap-daemon /etc/neutron/rootwrap.conf"
crudini --set ${NEUTRON_L3_CONFIG_FILE} AGENT root_helper "sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf"


# The cert that the nova-api-metadata server users is issued to the hostname, not IP
# so we have to turn host name validation off
################################################################################
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} DEFAULT nova_metadata_protocol "https"
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} DEFAULT nova_metadata_insecure "True"
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} DEFAULT nova_metadata_port "8775"
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} DEFAULT nova_metadata_ip "${NOVA_METADATA_SERVICE_HOST_SVC}"

crudini --set ${NEUTRON_METADATA_OVN_CONFIG_FILE} DEFAULT nova_metadata_protocol "https"
crudini --set ${NEUTRON_METADATA_OVN_CONFIG_FILE} DEFAULT nova_metadata_insecure "True"
crudini --set ${NEUTRON_METADATA_OVN_CONFIG_FILE} DEFAULT nova_metadata_port "8775"
crudini --set ${NEUTRON_METADATA_OVN_CONFIG_FILE} DEFAULT nova_metadata_ip "${NOVA_METADATA_SERVICE_HOST_SVC}"


################################################################################
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} AGENT root_helper_daemon "sudo /usr/bin/neutron-rootwrap-daemon /etc/neutron/rootwrap.conf"
crudini --set ${NEUTRON_METADATA_CONFIG_FILE} AGENT root_helper "sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf"
