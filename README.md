# Docker Compose setup for CKAN

![CKAN Versions](https://img.shields.io/badge/CKAN%20Versions-2.7.6%20|%202.8.3-success.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/openknowledge/ckan-base.svg)


* [Overview](#overview)
* [Quick start](#quick-start)
* [Development mode](#development-mode)
   * [Create an extension](#create-an-extension)
* [CKAN images](#ckan-images)
   * [Extending the base images](#extending-the-base-images)
   * [Applying patches](#applying-patches)
* [Known Issues](#known-issues)


## Overview

This is a set of Docker images and configuration files to run a CKAN site.

It is largely based on two existing projects:

* Keitaro's [CKAN Docker images](https://github.com/keitaroinc/docker-ckan)
* Docker Compose setup currently included in [CKAN core](https://github.com/ckan/ckan)


It includes the following images, all based on [Alpine Linux](https://alpinelinux.org/):

* CKAN: modified from keitaro/ckan (see [CKAN Images](#ckan-images)) for more details). File uploads are stored in a named volume.
* DataPusher: modified from keitaro/datapusher
* PostgreSQL: Official PostgreSQL image. Database files are stored in a named volume.
* Solr: official Solr image with CKAN's schema. Index data is stored in a named volume.
* Redis: standard Redis image

The site is configured via env vars (the base CKAN image loads [ckanext-envvars](https://github.com/okfn/ckanext-envvars)), that you can set in the `.env` file.

## Quick start

Available CKAN stacks: 2.7 (default), 2.8 and 2.9

Copy the included `.env.example` and rename it to `.env-2.7` (or substitute 2.7 with 2.8/2.9) to modify it depending on your own needs and update `DEV_CKAN_SITE_URL` and `CKAN_PORT` to port `5001` for 2.8 and `5002` for 2.9.

Using the default values on the `.env.example` file will get you a working CKAN instance. There is a sysadmin user created by default with the values defined in `CKAN_SYSADMIN_NAME` and `CKAN_SYSADMIN_PASSWORD`(`ckan_admin` and `test1234` by default). I shouldn't be telling you this but obviously don't run any public CKAN instance with the default settings.

To clone ckan and ckan extensions:

	./scripts/bootstrap.sh

To build the images, defaulting to CKAN 2.7:

	./scripts/rebuild-ckan.sh

To start the containers:

	./scripts/start-ckan.sh

## Development mode

To develop local extensions use the `docker-compose.dev.yml` file:

To setup your dev environment by cloning ckan and the extensions to your local src directory:

    ./scripts/bootstrap.sh <version> # eg ./scripts/bootstrap.sh 2.8  If no version is supplied the default of 2.7 is used

To build the images:

    ./scripts/rebuild-ckan.sh <version> #  eg ./scripts/bootstrap.sh 2.8  If no version is supplied the default of 2.7 is used. If starting from new, the script will take at least 15 minutes to run.

To start the containers:

	./scripts/start-ckan.sh <version>  eg ./scripts/bootstrap.sh 2.8  If no version is supplied the default of 2.7 is used

See [CKAN Images](#ckan-images) for more details of what happens when using development mode.

Find out names of running containers:

    docker ps

To ssh onto the ckan container:

    docker exec -it docker-ckan_ckan-postdev_1 bash

To ssh onto the postgres container:

    docker exec -it db psql -U ckan

To reset docker ckan -

for help

    ./scripts/reset-ckan.sh help

to pass in args

    ./scripts/reset-ckan.sh <image (postdev, ckan, dev, base)> <reset volumes (Yn)> <version (default 2.7, 2.8)>

### Updating CKAN configuration, production.ini

When you have to make changes to the CKAN config file, `production.ini`, update the `production.ini` file located in `ckan/setup` project to get a faster turn around time. Changing it on `ckan-base/setup` will increase the turn around time to more than 10 minutes rather than under 5 minutes within the `ckan` project. `production.ini` has been left in `ckan-base` because the Dockerfile in `ckan-base` has references to it.

### Running tests for extensions

#### ckanext-harvest

    nosetests --ckan  --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-harvest/test-core.ini ckanext.harvest

##### NOTE - updating gather or fetch processes

For the code to be picked up by supervisorctl, the process needs to be restarted

    supervisorctl restart ckan_fetch_consumer

    supervisorctl restart ckan_gather_consumer

#### ckanext-spatial

    nosetests --ckan --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-spatial/test.ini ckanext.spatial

#### ckanext-dcat

    nosetests --ckan --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-dcat/test.ini ckanext.dcat

#### ckanext-datagovuk

    nosetests --ckan -v --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini ckanext.datagovuk

#### ckan

    nosetests --ckan --with-pylons=$SRC_EXTENSIONS_DIR/ckan/test-core.ini ckan

#### target tests

    nosetests ... ckanext.<ckanext extension>.tests.<filename without .py>:<test class name>.<test class method>

    `replace ... with the nosetests args`

For example:

    nosetests --ckan -v --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini ckanext.datagovuk.tests.test_package:TestPackageController.test_package_create_show


### Create an extension

You can use the paster template in much the same way as a source install, only executing the command inside the CKAN container and setting the mounted `src/` folder as output:

    docker-compose -f docker-compose.dev.yml exec ckan-dev /bin/bash -c "paster --plugin=ckan create -t ckanext ckanext-myext -o /srv/app/src_extensions"

The new extension will be created in the `src/` folder. You might need to change the owner of its folder to have the appropiate permissions.

### Logs

All ckan logs are available under `./logs` on your machine.

### Running the remote debugger remote-pdb

This is useful when debugging tests.

Add the following line to the part of the code to set a breakpoint:

    import remote_pdb; remote_pdb.set_trace(host='0.0.0.0', port=3000)

Port 3000 is exposed for CKAN 2.7 stack, 3001 for 2.8, 3002 for 2.9
The remote debug port can be found in the docker-compose file and should be unique for each stack.

After a remote pdb session is available, `RemotePdb session open at 0.0.0.0:3000`, then on another terminal connect to the debugger using `telnet`:

    telnet localhost 3000

NOTE - update the telnet port depending on the CKAN version you are running.

You should now be connected to the debugger to start your investigations.

### Accessing ckan publisher and csw endpoint via Nginx

CKAN publisher:

  http://localhost:5000/

Port 5000 is available for CKAN 2.7, 5001 for 2.8, 5002 for 2.9.
The nginx port exposed can be found in the docker-compose file.

CSW endpoint:

  http://locahost:5000/csw

CSW summary:

  http://localhost:5000/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&elementsetname=brief

NOTE - update 5000 with the relevant port for the CKAN version you are running

## CKAN images

```
    +-------------------------+                +----------+
    |                         |                |          |
    | openknowledge/ckan-base +---------------->   ckan   | (production)
    |                         |                |          |
    +-----------+-------------+                +----------+
                |
                |
    +-----------v------------+                 +----------+
    |                        |                 |          |
    | openknowledge/ckan-dev +----------------->   ckan   | (development)
    |                        |                 |          |
    +------------------------+                 +----------+


```

The Docker images used to build your CKAN project are located in the `ckan/` folder. There are two Docker files:

* `Dockerfile`: this is based on `openknowledge/ckan-base` (with the `Dockerfile` on the `/ckan-base/<version>` folder), an image with CKAN with all its dependencies, properly configured and running on [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/) (production setup)
* `Dockerfile.dev`: this is based on `openknowledge/ckan-dev` (with the `Dockerfile` on the `/ckan-dev/<version>` folder), which extends `openknowledge/ckan-base` to include:

  * Any extension cloned on the `src` folder will be installed in the CKAN container when booting up Docker Compose (`docker-compose up`). This includes installing any requirements listed in a `requirements.txt` (or `pip-requirements.txt`) file and running `python setup.py develop`.
  * The CKAN image used will development requirements needed to run the tests .
  * CKAN will be started running on the paster development server, with the `--reload` option to watch changes in the extension files.
  * Make sure to add the local plugins to the `CKAN__PLUGINS` env var in the `.env` file.

From these two base images you can build your own customized image tailored to your project, installing any extensions and extra requirements needed.

### Extending the base images

To perform extra initialization steps you can add scripts to your custom images and copy them to the `/docker-entrypoint.d` folder (The folder should be created for you when you build the image). Any `*.sh` and `*.py` file in that folder will be executed just after the main initialization script ([`prerun.py`](https://github.com/okfn/docker-ckan/blob/master/ckan-base/setup/prerun.py)) is executed and just before the web server and supervisor processes are started.

For instance, consider the following custom image:

```
ckan
├── docker-entrypoint.d
│   └── setup_validation.sh
├── Dockerfile
└── Dockerfile.dev

```

We want to install an extension like [ckanext-validation](https://github.com/frictionlessdata/ckanext-validation) that needs to create database tables on startup time. We create a `setup_validation.sh` script in a `docker-entrypoint.d` folder with the necessary commands:

```bash
#!/bin/bash

# Create DB tables if not there
paster --plugin=ckanext-validation validation init-db -c $CKAN_INI
```

And then in our `Dockerfile` we install the extension and copy the initialization scripts:

```Dockerfile
FROM openknowledge/ckan-dev:2.7

RUN pip install -e git+https://github.com/frictionlessdata/ckanext-validation.git#egg=ckanext-validation && \
    pip install -r https://raw.githubusercontent.com/frictionlessdata/ckanext-validation/master/requirements.txt

COPY docker-entrypoint.d/* /docker-entrypoint.d/
```

### Applying patches

When building your project specific CKAN images (the ones defined in the `ckan/` folder), you can apply patches
to CKAN core or any of the built extensions. To do so create a folder inside `ckan/patches` with the name of the
package to patch (ie `ckan` or `ckanext-??`). Inside you can place patch files that will be applied when building
the images. The patches will be applied in alphabetical order, so you can prefix them sequentially if necessary.

For instance, check the following example image folder:

```
ckan
├── patches
│   ├── ckan
│   │   ├── 01_datasets_per_page.patch
│   │   ├── 02_groups_per_page.patch
│   │   ├── 03_or_filters.patch
│   └── ckanext-harvest
│       └── 01_resubmit_objects.patch
├── Dockerfile
└── Dockerfile.dev

```


## Known Issues

* The SOLR index does not contain harvest metadata which is required by the CSW load job. A work around has been to run a solr reindex cronjob every 5 minutes to ensure that it picks up the latest when a harvest job is run. On production there is a similar cron job running but it only runs once a day.
