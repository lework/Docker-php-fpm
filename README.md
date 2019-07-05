## Docker-php-fpm

![docker hub](https://img.shields.io/docker/pulls/lework/php-fpm.svg?style=flat-square)
![docker hub](https://img.shields.io/docker/stars/lework/php-fpm.svg?style=flat-square)

基于php-alpine基础镜像的php环境，包含常用的php扩展包

## Versioning
| Docker Tag | Git Release | Nginx Version | PHP Version | Alpine Version |
|-----|-------|-----|--------|--------|
| latest/7.1.30-nginx-alpine3.9 | Master Branch |1.14.2 | 7.1.30 | 3.9 |
| 7.1.30-nginx-alpine3.9 | 7.1.30-nginx-alpine3.9 |1.14.2 | 7.1.30 | 3.9 |
| 7.1.24-fpm-alpine3.8 | 7.1.24-fpm-alpine3.8 | | 7.1.30 | 3.8 |


## Quick Start

```
docker run -tid -v ./php/src:/src -p 80:80 lework/php-fpm:latest
```
