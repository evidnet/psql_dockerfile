# psql_dockerfile

에비드넷 서버에서 사용하기 위한 PostgreSQL Dockerfile입니다.

## 새로 설치하는 방법

0. `/etc/docker/daemon.json`을 다음과 같이 설정해주세요.
  ```json
  {
    "insecure-registries": ["docker.evidnet.co.kr"]
  }
  ```
1. PostgreSQL 데이터가 저장될 폴더를 만들어주세요. (ex. `mkdir /data/psql`)
2. `docker pull docker.evidnet.co.kr/base-images/evidnet/psql:v...` 명령어를 통해 Docker 이미지를 내려받아주세요. (`v...` 부분을 버전 이름으로 꼭 바꿔주세요.)
3. 다음과 같은 커맨드를 통해 컨테이너를 생성해주세요. (ex. `docker run -d -p 5432:5432 --name psql -v /data/psql:/var/lib/postgresql/10/main -itd --restart always psql:v1.0`)
4. Docker 컨테이너 내로 진입한 뒤, `postgres` 사용자로 `psql`을 실행시켜주세요.
  ```
  docker exec -it psql bash
  sudo -u postgres psql
  ```
5. `\password;` 명령을 통해 초기 비밀번호를 설정해주세요.

## 기존 버전에서 업데이트하는 법

여기서는 기존 컨테이너 이름이 `psql`인 것으로 가정하고 방법을 작성하였습니다.

0. `/etc/docker/daemon.json`을 다음과 같이 설정해주세요.
  ```json
  {
    "insecure-registries": ["docker.evidnet.co.kr"]
  }
  ```
1. `docker pull docker.evidnet.co.kr/base-images/evidnet/psql:v...` 명령어를 통해 Docker 이미지를 내려받아주세요. (`v...` 부분을 버전 이름으로 꼭 바꿔주세요.)
2. `docker stop -t 15 psql`이라는 명령어를 통해 기존 컨테이너를 종료해주세요. 시간이 조금 소요될 수 있습니다.
3. `docker rm psql` 명령어를 통해 종료된 컨테이너를 삭제해주세요. 컨테이너를 삭제해도 데이터는 안전합니다.
4. 처음 Docker 컨테이너를 만들었던 것과 같은 옵션으로 컨테이너를 생성해주세요. 당연히 이미지 옵션은 새 이미지로 설정해주셔야합니다.
    (ex. `docker run -d -p 5432:5432 --name psql -v /data/psql:/var/lib/postgresql/10/main -itd --restart always psql:v1.0`)
5. 정상적으로 실행되는지 로그를 확인합니다. (`docker logs -f psql`)

## Changelog

### v1.0-beta
 - **Released At**: 2019-01-17
 - **[CRITICAL]** `docker stop` 명령어를 통해 컨테이너를 종료해도 안전하게 서비스를 종료할 수 있게끔 프로세스의 Kill 시그널을 가로채는 로직을 추가했습니다.
 - **[PERFORMANCE]** 성능 향상을 위한 파라미터 튜닝값들을 적용했습니다. (락플레이스에서 제안받은 설정값)
