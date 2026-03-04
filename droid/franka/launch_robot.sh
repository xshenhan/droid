source /root/miniconda3/etc/profile.d/conda.sh
conda activate polymetis-local
pkill -9 run_server
pkill -9 franka_panda_cl
launch_robot.py robot_client=franka_hardware \
  port=${POLYMETIS_PORT:-50051} \
  robot_client.executable_cfg.robot_ip=${ROBOT_IP:-172.16.0.2}
