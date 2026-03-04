```
# build
source scripts/setup/set_env.sh && docker compose -f .docker/nuc/docker-compose-nuc.yaml build nuc-0.15.0  
source scripts/setup/set_env.sh && docker compose -f .docker/nuc/docker-compose-nuc.yaml build nuc-0.18.0  
```

```
# run
docker compose -f .docker/nuc/docker-compose-nuc-0.15.0.yaml up -d
docker compose -f .docker/nuc/docker-compose-nuc-0.18.0.yaml up -d
docker exec -it droid_nuc_0.17.0 bash droid/franka/launch_robot.sh
docker exec -it droid_nuc_0.18.0 bash droid/franka/launch_robot.sh
```


docker exec droid_nuc_0.17.0 bash -c "source /root/miniconda3/etc/profile.d/conda.sh && conda activate polymetis-local && python -c \"
import franka
r = franka.Robot('172.16.1.2', franka.RealtimeConfig.kIgnore if hasattr(franka, 'RealtimeConfig') else 0)
r.automaticErrorRecovery()
print('Recovered')
\" 2>/dev/null || echo 'Already recovered'"