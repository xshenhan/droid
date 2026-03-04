import os

import zerorpc

from droid.franka.robot import FrankaRobot

if __name__ == "__main__":
    port = os.environ.get("ZERORPC_PORT", "4242")
    robot_client = FrankaRobot()
    s = zerorpc.Server(robot_client)
    s.bind(f"tcp://0.0.0.0:{port}")
    s.run()
