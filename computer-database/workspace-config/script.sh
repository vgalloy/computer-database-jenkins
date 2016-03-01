if [ -e $(docker ps -aq -f "name=computer-database-mysql-test") ]
then 
	docker create --name=computer-database-mysql-test -e MYSQL_ROOT_PASSWORD=root vgalloy/computer-database-mysql-test
fi
docker start computer-database-mysql-test
sleep 3
if [ -e $(docker ps -aq -f "name=computer-database-builder") ]
then 
	docker create --name=computer-database-builder --link computer-database-mysql-test:localhost -w /opt/cdb maven:3.3.3-jdk-8 mvn clean package
fi
docker cp . computer-database-builder:/opt/cdb
docker start -a computer-database-builder
docker stop computer-database-mysql-test

docker cp computer-database-builder:/opt/cdb/webapp/target/webapp-1.0-RELEASE.war webapp.war
docker build -t vgalloy/computer-database-webapp .
docker push vgalloy/computer-database-webapp

bash glazer-deploy.sh --host 192.168.10.225 --port 65000 --env MYSQL_ROOT_PASSWORD=root vgalloy-computer-database-mysql vgalloy/computer-database-mysql-prod
bash glazer-deploy.sh --host 192.168.10.225 --port 65000 --link vgalloy-computer-database-mysql:localhost --publish 65100:8080 vgalloy-computer-database-webapp vgalloy/computer-database-webapp
