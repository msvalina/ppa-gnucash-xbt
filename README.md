# Unofficial build of GnuCash with Bitcoin support for Ubuntu Bionic

## Install GnuCash with Bitcoin support

[Ubuntu PPA:msvalina/gnucash](https://launchpad.net/~msvalina/+archive/ubuntu/gnucash)

```shell
sudo add-apt-repository ppa:msvalina/gnucash
sudo apt-get update
```

### This Docker image will

* build the environment for building GnuCash
* build debian source package
* sign it with gpg (works with YubiKey)
* upload it to the Ubuntu (PPA) Personal Package Archive.

Code is mostly self explanatory. At least for people familiar with tools used.

### Build image

```shell
docker build . -t gnucash-xbt-ubuntu-bionic-pkgbuild
```

### Run container

```shell
$ docker run --rm -ti \
    -v ${HOME}/.gnupg/:/home/ubuntu/.gnupg/:ro \
    -v /run/user/$(id -u)/:/run/user/$(id -u)/:ro  \
    -v ${HOME}/path/to/ppa-gnucash-xbt/:/home/ubuntu/ppa-gnucash-xbt/ \
    --name dpkg-build-gnucash \
    gnucash-xbt-ubuntu-bionic-pkgbuild bash
```

## Building puzzles and thanks

* Benedykt Przybyło (b3niup) for original Archlinux [AUR PKBUILD gnucash-xbt](https://aur.archlinux.org/packages/gnucash-xbt/) and xbt.patch
* Dmitry Smirnov for maintaining [Debian GnuCash dpkgbuild](Dmitry Smirnov <onlyjob@member.fsf.org>)
* Dale Phurrough for nice GnuCash Dockerfile starting point: [diablodale/gnucash-dev-docker](https://github.com/diablodale/gnucash-dev-docker/)
* Sicklylife for maintaining [GnuCash Ubuntu PPA](https://launchpad.net/~sicklylife/+archive/ubuntu/gnucash3.6) with vanilla latest builds and providing blueprint for building dpkg-build
* Andrey Arapov of nixaid.com for writing [Using GPG inside a docker container]( https://nixaid.com/using-gpg-inside-a-docker-container/)
