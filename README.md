# PostgreSQL Docker Image

## How to use ?

`docker build -t psql .`
`docker run -d -p 5432:5432 --name psql -v HostDataDirecotry:/var/lib/postgresql/10/main --env 'PG_PASSWORD=password' -itd --restart always psql:latest`
