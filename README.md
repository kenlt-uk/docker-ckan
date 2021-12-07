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

Available CKAN stacks: 2.7, 2.8 (default) and 2.9

Copy the included `.env.example` and rename it to `.env-2.8` (or substitute 2.8 with 2.7/2.9) to modify it depending on your own needs and update `DEV_CKAN_SITE_URL` and `CKAN_PORT` to port `5001` for 2.8 or `5002` for 2.9.

Using the default values on the `.env.example` file will get you a working CKAN instance. There is a sysadmin user created by default with the values defined in `CKAN_SYSADMIN_NAME` and `CKAN_SYSADMIN_PASSWORD`(`ckan_admin` and `test1234` by default). I shouldn't be telling you this but obviously don't run any public CKAN instance with the default settings.

To clone ckan and ckan extensions:

	./scripts/bootstrap.sh

To build the images, defaulting to CKAN 2.8, pulling down govuk/ckan-main and building only the postdev container:

	./scripts/rebuild-ckan.sh

To start the containers:

	./scripts/start-ckan.sh

### Running the full datagovuk stack

NOTE: In order to run elasticsearch you will need to set your Docker memory to 4 gb and Docker swap memory to 2 gb, otherwise elasticsearch will stop with error code 137.

To clone ckan and ckan extensions with 2.8:

	./scripts/bootstrap.sh 2.8 full

To build the images, defaulting to CKAN 2.8, pulling down govuk/ckan-main and building only the postdev container:

	./scripts/rebuild-ckan.sh 2.8 full

To start the containers:

	./scripts/start-ckan.sh 2.8 full

## Development mode

To setup your dev environment by cloning ckan and the extensions to your local src directory:

    ./scripts/bootstrap.sh <version> <?full>  # eg ./scripts/bootstrap.sh 2.8  If no version is supplied the default of 2.7 is used, the optional full flag can be used to also build the stack with DGU publish (https://github.com/alphagov/datagovuk_publish) and Find (https://github.com/alphagov/datagovuk_find)

To build the images:

    ./scripts/rebuild-ckan.sh <version> <?(main, all)> <?full>  #  eg ./scripts/bootstrap.sh 2.8  
    - If no version is supplied the default of 2.8 is used. If starting from new, the script will take at least 20 minutes to run. 
    - If `all` is passed as a second argument all the docker project will be rebuilt. If `main` is passed in the ckan-main and ckan-postdev projects will be built. Otherwise the docker image from dockerhub for ckan-main will be pulled and only postdev will be built.
    - if `full` is passed in as an argument Publish (https://github.com/alphagov/datagovuk_publish) and Find (https://github.com/alphagov/datagovuk_find) will also be built as part of the stack.

To start the containers:

	./scripts/start-ckan.sh <version> <?full> eg ./scripts/bootstrap.sh 2.8  If no version is supplied the default of 2.8 is used. If full is supplied as the second argument DGU Publish (https://github.com/alphagov/datagovuk_publish) and Find (https://github.com/alphagov/datagovuk_find) will also be started on the stack.

See [CKAN Images](#ckan-images) for more details of what happens when using development mode.

Find out names of running containers:

    docker ps

To ssh onto the ckan container:

    docker exec -it ckan-2.8 bash

To ssh onto the postgres container:

    docker exec -it db psql -U ckan

To reset docker ckan -

for help

    ./scripts/reset-ckan.sh help

to pass in args

    ./scripts/reset-ckan.sh <image (postdev, main, dev, base)> <reset volumes (Yn)> <version (default 2.8, 2.7, 2.9)> <?full to remove Publish and Find images and elasticsearch volume>

### Updating CKAN configuration, production.ini

When you have to make changes to the CKAN config file, `production.ini`, update the `production.ini` file located in `ckan-main/setup` project to get a faster turn around time. Changing it on `ckan-base/setup` will increase the turn around time to more than 10 minutes rather than under 5 minutes within the `ckan-main` project. `production.ini` has been left in `ckan-base` because the Dockerfile in `ckan-base` has references to it. You will also need to run `./scripts/rebuild-ckan.sh main` in order to rebuild the image from your local changes rather than use the image in docker hub.

### Updating code in CKAN and its extensions

Sometimes the changes made on your local machine won't be reflected in the docker container, so in order to copy these changes across you can use this command:

`export CKANEXT_SRC=<CKAN extension, eg datagovuk> && sudo rsync -avz --update --existing --progress ./src_extensions/ckanext-$CKANEXT_SRC/ ./src/ckanext-$CKANEXT_SRC/`

This should pick up any changes that match existing files to `/srv/app/src/<CKAN extension>`, any files that you added will have to be manually copied across. If you want to copy over everything regardless then simply remove `--existing` from the command.

### Useful tips during development

#### Problems logging in

If you cannot log in with the credentials in your `.env` file, it's possible that the CKAN auth session has been corrupted, perhaps due to restarting the stack. As there may be a number of reasons why it is failing, you can try these to resolve it:

- clear all the application cookies from the browser
- recreate the admin user in the container - `paster --plugin=ckan sysadmin add admin email=admin@localhost name=admin -c $CKAN_INI`

#### Docker container is not staying up

If the CKAN container is unable to stay healthy, it's possible that there has been a code change in your CKAN or extension code, so move the targeted source folder, e.g `src/2.8` to `src/2.8.bak`, if you want to still see your changes, or delete the folder. Then run `./scripts/bootstrap.sh` to download all the repositories again and start fresh.

If the problem persists even after running a `./scripts/reset-ckan.sh`, it may be possible that there is an issue with the docker images / containers. In this case it's best to clear docker images and volumes down entirely. These commands will enable you to do that, note that they will remove images and volumes so only use this as a last resort.

    docker volume rm $(docker volume ls --filter dangling=true -q)
    docker rmi -f $(docker images --filter dangling=true -qa)
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    docker network prune -f
    docker rmi -f $(docker images --filter dangling=true -qa)

#### Manually starting up a container

This may be useful in order to get the container running if it is not staying up.

Comment out the existing `command` line in relevant `docker-compose.yml` file and add another `command`:

    command: bash -c "tail -f /dev/null"

Then you will have to exec into the container, which should be something like this:

    docker exec -it <container name> bash

You may need to replace `bash` with `sh` or an equivalent if that doesn't work.

Once on the docker container you need to run the script that starts up the app,for CKAN this is:

    ./start_ckan_development.sh

#### Manually running a harvest job

In order to run a harvest job manually, you need to run these commands on the container (2.7, 2.8):

    paster --plugin=ckanext-harvest harvester run_test <test-harvest-source-name> -c $CKAN_INI

For 2.9:

    ckan -c $CKAN_INI harvester run-test <test-harvest-source-name>

The `test-harvest-source-name` can be derived from the URL after creating a harvest source.

#### Creating organogram datasets

In order to create a sample organogram dataset you will need to follow these steps:

- Under the Datasets tab click on `Add Dataset`
- Select the Organisation structure including senior roles for central government from the schema/vocabulary drop down menu
- On the next page upload an organogram from your clone of [ckanext-datagovuk](https://github.com/alphagov/ckanext-datagovuk) located at `ckanext/datagovuk/tests/data` depending on the scenario that you want.

#### Database / Redis / Solr is not found during tests

If you have checked out a branch of CKAN or one of the extensions its possible that the config settings have been reset when pulling down the commits if you do this whilst the docker stack is still running.

You can initialise the CKAN config by running this command -

    /srv/app/init_config.sh

For extensions run the relevant `setup` file found in `/docker-entrypoint.d`, e.g. if you changed the harvest branch run `/docker-entrypoint.d/setup_harvest.sh`

#### Container doesn't have additional files or updates to files

It's possible that one of the images failed to build so docker is using a cached version of the image to build the container. 
To fix the docker image it may be necessary to build the stack without using cached images:

    ../scripts/rebuild-ckan.sh 2.8 dev no-cache

Will rebuild the stack from the `ckan-dev` Dockerfile.

## Testing

A [testing document](TESTING.md) is available which describes the testing tools available, how we use them, and possible plans for the future.

### Running tests for extensions

### 2.7 and 2.8

#### ckanext-harvest

    nosetests --ckan  --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-harvest/test-nose.ini ckanext.harvest

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

#### Target tests

    nosetests ... ckanext.<ckanext extension>.tests.<filename without .py>:<test class name>.<test class method>

    `replace ... with the nosetests args`

For example:

    nosetests --ckan -v --nologcapture --with-pylons=$SRC_EXTENSIONS_DIR/ckanext-datagovuk/test.ini ckanext.datagovuk.tests.test_package:TestPackageController.test_package_create_show

### 2.9

#### ckanext-harvest

    (cd $SRC_EXTENSIONS_DIR/ckanext-harvest && python -m pytest --ckan-ini=test.ini ckanext/harvest/tests --disable-pytest-warnings -v)

#### ckanext-spatial

    (cd $SRC_EXTENSIONS_DIR/ckanext-spatial && python -m pytest --ckan-ini=test.ini ckanext/spatial/tests --disable-pytest-warnings -v)

#### ckanext-dcat

    (cd $SRC_EXTENSIONS_DIR/ckanext-dcat && python -m pytest --ckan-ini=test.ini ckanext/dcat/tests --disable-pytest-warnings -v)

#### ckanext-datagovuk

    (cd $SRC_EXTENSIONS_DIR/ckanext-datagovuk && python -m pytest --ckan-ini=test.ini tests --disable-pytest-warnings -v)

#### Target tests

    (cd $SRC_EXTENSIONS_DIR/ckanext-<extension> && python -m pytest --ckan-ini=test.ini ckanext/<extension>/tests/<test file>::<class>.<test name> --disable-pytest-warnings -v)

    for datagovuk:

    (cd $SRC_EXTENSIONS_DIR/ckanext-datagovuk && python -m pytest --ckan-ini=test.ini tests/<test file>::<class>::<test name> --disable-pytest-warnings -v)

For example:

    (cd $SRC_EXTENSIONS_DIR/ckanext-spatial && python -m pytest --ckan-ini=test.ini ckanext/spatial/tests/test_harvest.py::TestHarvest::test_harvest_deleted_record --disable-pytest-warnings -v)

#### Troubleshooting tests

If you are experiencing problems running the tests you can run these commands to reset the test config and test database:

```
# initialise the CKAN and extension configs
source ./init_config.sh

# drop postgis extension and log_level type from test database to enable tests to run
PGPASSWORD=ckan psql -h db -U ckan -d ckan_test -c "DROP EXTENSION IF EXISTS postgis CASCADE; DROP TYPE IF EXISTS log_level CASCADE;"
```

For spatial tests also run this script if they continue to fail - 

    source /docker-entrypoint.d/setup_spatial.sh

### Create an extension

You can use the paster template in much the same way as a source install, only executing the command inside the CKAN container and setting the mounted `src/` folder as output:

    docker-compose -f docker-compose.dev.yml exec ckan-dev /bin/bash -c "paster --plugin=ckan create -t ckanext ckanext-myext -o /srv/app/src_extensions"
 
The new extension will be created in the `src/` folder. You might need to change the owner of its folder to have the appropiate permissions.

### Logs

All ckan logs are available under `./logs` on your machine.

Datagov UK Publish sidekiq logs are available under `sidekiq.log`

Datagov UK Find logs are available under `find.log`

### Running the remote debugger remote-pdb

This is useful when debugging tests on 2.7 and 2.8.
For 2.9 the standard `pdb` library appears to be working.

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

### Accessing Find website

When running with the 2.8 CKAN stack navigate to:

    http://localhost:4001

Port 4000 is available for CKAN 2.7, 4001 for 2.8, 4002 for 2.9.

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

The Docker images used to build your CKAN project are located in the `ckan-main/` folder. There are two Docker files:

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

When building your project specific CKAN images (the ones defined in the `ckan-main/` folder), you can apply patches
to CKAN core or any of the built extensions. To do so create a folder inside `ckan-main/patches` with the name of the
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

## Mock harvest source

### Static

The docker compose configurations start an instance of the static [mock harvest source](https://github.com/alphagov/ckan-mock-harvest-sources)
which should make it easy to populate the database with some basic standard content. To use this, add a harvest
source with the address `http://static-mock-harvest-source-2.8:11088` and of type "CKAN". The content served by this
harvest source is live modifiable from the `src/<version>/ckan-mock-harvest-sources/static/responses/` directory.

For this harvest source to appear to work _completely_ right, you may need to add the hostname
`static-mock-harvest-source` to your host machine's `/etc/hosts` file as an alias to `127.0.0.1`. This is because
CKAN's web interface will link "directly" to the actual data files (and of course, it will be doing so using the
hostname _it_ knows it by), so you have to do some tweaking of your host machine's configuration to allow your
browser to resolve that address correctly.

### Dynamic

The docker compose configurations also start an instance of the dynamic [mock harvest source](https://github.com/alphagov/ckan-mock-harvest-sources)
which can be used to test out harvesting. To use this, add a harvest
source with the address `http://dynamic-mock-harvest-source-2.8:8001/1/` and of type "WAF". 

Further documentation about the dynamic mock harvest source can be [read](https://github.com/alphagov/ckan-mock-harvest-sources/tree/master/dynamic) which which will enable you to define the number of datasets available for harvesting and the delay on the harvest source server.

## Known Issues

* The SOLR index does not contain harvest metadata which is required by the CSW load job. A work around has been to run a solr reindex cronjob every 5 minutes to ensure that it picks up the latest when a harvest job is run. On production there is a similar cron job running but it only runs once a day.
* The `-dev` dependencies of all discovered extensions are installed into the python environment at startup time by default, but this can lead to conflicts. If this leads to trouble getting test suites to pass, the variable `DEV_EXTENSIONS_WHITELIST` can be set to a comma-separated list of extensions (by directory name under `$SRC_EXTENSIONS_DIR`) for which dev dependencies should be installed.
