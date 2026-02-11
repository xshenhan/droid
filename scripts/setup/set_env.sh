#!/bin/bash

# Read the parameter values from the Python script using awk and convert to env variables
echo "Set environment variables from parameters file"

PARAMETERS_FILE="$(git rev-parse --show-toplevel)/droid/misc/parameters.py"
awk -F'[[:space:]]*=[[:space:]]*' '/^[[:space:]]*([[:alnum:]_]+)[[:space:]]*=/ && $1 != "ARUCO_DICT" { gsub("\"", "", $2); print "export " $1 "=" $2 }' "$PARAMETERS_FILE" > /tmp/droid_env_vars.sh
source /tmp/droid_env_vars.sh

export ROOT_DIR=$(git rev-parse --show-toplevel)
export NUC_IP=$nuc_ip
export ROBOT_IP=$robot_ip
export LAPTOP_IP=$laptop_ip
export SUDO_PASSWORD=$sudo_password
export ROBOT_TYPE=$robot_type
export ROBOT_SERIAL_NUMBER=$robot_serial_number
export HAND_CAMERA_ID=$hand_camera_id
export VARIED_CAMERA_1_ID=$varied_camera_1_id
export VARIED_CAMERA_2_ID=$varied_camera_2_id
export UBUNTU_PRO_TOKEN=$ubuntu_pro_token
rm /tmp/droid_env_vars.sh

if [ "$ROBOT_TYPE" = "panda" ]; then
        export LIBFRANKA_VERSION=0.9.0
else
        export LIBFRANKA_VERSION=0.18.0
fi

echo "Done. ROBOT_TYPE=$ROBOT_TYPE, LIBFRANKA_VERSION=$LIBFRANKA_VERSION, NUC_IP=$NUC_IP"
