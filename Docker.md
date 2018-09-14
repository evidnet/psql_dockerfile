# Docker 를 Root 혹은 sudo 유저에서만 접근 가능하게 하는 법

1. `root`로 로그인
2. 다음과 같은 쉘 커맨드를 실행한다.

```sh
chmod 500 /var/run/docker.sock
```

3. 끝.
