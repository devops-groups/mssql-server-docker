# Microsoft SQL Server

## Supported tags and respective Dockerfile links

* [14.0](https://github.com/devops-groups/mssql-server-docker/blob/14.0/Dockerfile)
* [latest](https://github.com/devops-groups/mssql-server-docker/blob/master/Dockerfile)

## How to use this image

```
$ docker run -d \
-e MSSQL_SA_PASSWORD=Pa55word \
-e MSSQL_DATABASE_NAME=nSaleForce \
-e ACCEPT_EULA=Y \
-p 1433:1433 \
--name msserver devopsgroups/mssql-server-linux
```

https://hub.docker.com/r/devopsgroups/mssql-server-linux

### Persist your data

https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-docker?view=sql-server-2017#persist

> Host volume mapping for Docker on Mac with the SQL Server on Linux image is not supported at this time. Use data volume containers instead. This restriction is specific to the `/var/opt/mssql` directory. Reading from a mounted directory works fine. For example, you can mount a host directory using –v on Mac and restore a backup from a .bak file that resides on the host.

## Environment Variables

* **ACCEPT_EULA** confirms your acceptance of the End-User Licensing Agreement.

* **SA_PASSWORD** is the database system administrator (userid = 'sa') password used to connect to SQL Server once the container is running. Important note: This password needs to include at least 8 characters of at least three of these four categories: uppercase letters, lowercase letters, numbers and non-alphanumeric symbols.

* **MSSQL_PID** is the Product ID (PID) or Edition that the container will run with. Acceptable values:

* **Developer** : This will run the container using the Developer Edition (this is the default if no MSSQL_PID environment variable is supplied)
  * Express : This will run the container using the Express Edition
  * Standard : This will run the container using the Standard Edition
  * Enterprise : This will run the container using the Enterprise Edition
  * EnterpriseCore : This will run the container using the Enterprise Edition Core
    <valid product id> : This will run the container with the edition that is associated with the PID
    For a complete list of environment variables that can be used, refer to the documentation here.

* **MSSQL_DATABASE_NAME** Create the database when the system start and  initializes.


## Reference

* https://hub.docker.com/r/microsoft/mssql-server-linux/
* https://databaseinternalmechanism.com/2017/09/14/sql-server-on-linux-directory-structure/
* https://adilsoncarvalho.com/using-mssql-on-linux-using-docker-for-mac-a5d4ac81e57f
* https://github.com/Microsoft/mssql-docker/issues/12
* https://cardano.github.io/blog/2017/11/15/mssql-docker-container
