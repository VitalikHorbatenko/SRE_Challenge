#!/bin/bash

# Steps to configure the script
# 1. Download the script to your home directory on the Linux hosting or the local Linux machine
# 2. Please replace the following values in the script with your own values:
#  - URL: Enter the URL of the website you want to check.
#  - THRESHOLD: Set the download time threshold. If the website load time exceeds this value, a notification will be sent.
#  - SLACK_WEBHOOK_URL: it should be retrieved from SLack
# 3. Open the editor crontab:
#   crontab -e
# 4. Add such rows to the crontab and configure the code execution frequency:
#   * * * * * /path/to/your/script.sh
# Each asterisk corresponds to a certain time parameter:
#  *: minute (0–59)
#  *: hour (0–23)
#  *: day of the month (1-31)
#  *: month (1–12)
#  *: day of the week (0–7, where Sunday can be either 0 or 7)
#  5. Set up secure permissions and make the script executable
#    chmod 700 /path/to/your/script.sh
#  6. Check if the script works correctly
#   bash /path/to/your/script.sh

# Here’s a concise guide to fetching an Incoming Webhook URL

# 1. Create a Slack channel or use an existing one.
# 2. Go to Slack API: https://api.slack.com/apps
# 3. Create a new application:
# 3.1. If you don't have an app for your workspace, click "Create New App".
# 3.2. Select the option "From scratch" and specify a name for the application.
# 4. Configure Incoming Webhooks:
# 4.1. After creating the app, select "Incoming Webhooks" from the menu on the left.
# 4.2. Enable Incoming Webhooks by toggling the appropriate switch.
# 5. Add a new webhook to the workspace:
# 5.1. Click the "Add New Webhook to Workspace" button.
# 5.2. Select the channel to which the webhook should send messages and click "Allow".
# 6. Copy the webhook URL and replace it with SLACK_WEBHOOK_URL in this scrpipt.


# Configurations
URL="https://example.com"                     # URL to be checked
THRESHOLD=0.1                                 # Treshold in sec

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/your/slack/webhook"  # URL of the Incoming Webhook to Slack 

# The overall download time with the help of cURL
TIME_TOTAL=$(curl -o /dev/null -s -w "%{time_total}\n" $URL)

# Checking if the website load exceeds the treshold
# bc -l is used to handle floating-point comparisons
 if (( $(echo "$TIME_TOTAL > $THRESHOLD" | bc -l) )); then
  # If the load time exceeds the treshold, the following message is sent to Slack
  MESSAGE="⚠️ The load time of $URL was $TIME_TOTAL seconds, which exceeds the threshold of $THRESHOLD seconds."

  # Sending the message via Incoming Webhook to Slack
  curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$MESSAGE\"}" $SLACK_WEBHOOK_URL
fi

