#!/bin/bash

# Slack incoming web-hook URL and user name
WEBHOOK='WEBHOOK'		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='Zabbix'

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "channel")
to="$1"

#The action's subject
# e.g.
# Problem: {TRIGGER.NAME} - {HOST.NAME} ({IPADDRESS})
subject="$2" 

# the message from zabbix.
# e.g.
# Problem started at {EVENT.TIME} on {EVENT.DATE}
# Problem name: {TRIGGER.NAME}
# Host: {HOST.NAME}
# Severity: {TRIGGER.SEVERITY}
# Original problem ID: {EVENT.ID}
# {TRIGGER.URL}
message="$3"

# Change message emoji depending on the subject - smile (RECOVERY/OK), frowning (PROBLEM), or ghost (for everything else)
status=${subject%%\:*}
echo $status
if [[ "$status" == 'Resolved' ]]; then
	emoji=':smile:'
	color="#2eb886"
elif [ "$status" == 'Acknowledged' ]; then
	emoji=':smile:'
	color="good"
elif [ "$status" == 'Problem' ]; then
	emoji=':frowning:'
	color="danger"
else
	emoji=':ghost:'
	color='warning'
fi


payload="{
	\"attachments\": [{\
		\"pretext\":\"<!here> ${emoji} ${subject}\", \
		\"text\": \"$message\",\
		\"color\": \"${color}\"}], \
	\"channel\": \"${to}\",\
	\"username\": \"${username}\",\
	\"icon_emoji\": \":zabbix:\"
}"

curl -m 5 --data-urlencode "payload=${payload}" $WEBHOOK
