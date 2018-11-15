#!/bin/bash
set -ev
# Make sure starter fixtures can load successfully and all tests pass.
# Run tests with --keepdb to avoid OperationalError during teardown, in case
# any db connections are stillr open from threads in TransactionTestCases.

docker exec -it nginx_express_phpmyadmin sh -c "nc -z -v node_app_test:3000"
docker exec -it nginx_express_phpmyadmin sh -c "ping  -c 4 node_phpmyadmin_test"
docker exec -it node_app_test sh -c "ping  -c 4 nginx_express_phpmyadmin"
docker exec -it node_app_test sh -c "ping  -c 4 node_mariadb_test"
docker exec -it node_app_test sh -c "nc -z -v node_mariadb_test 3306"
docker logs node_app_test
curl http://localhost:8000/test --connect-timeout 20  --progress-bar # output json write data in mysql