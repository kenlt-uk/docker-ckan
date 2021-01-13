import os
import sys
import subprocess
import psycopg2
from urllib.request import urlopen
from urllib.error import URLError
import time
import re

ckan_ini = os.environ.get('CKAN_INI', '/srv/app/production.ini')
test_ckan_ini = os.environ.get('TEST_CKAN_INI', '/srv/app/src/test-core.ini')

RETRY = 5

def update_plugins():

    plugins = os.environ.get('CKAN__PLUGINS', '')
    print('[prerun] Setting the following plugins in {}:'.format(ckan_ini))
    print(plugins)
    cmd = ['ckan', 'config-tool',
           ckan_ini, 'ckan.plugins = {}'.format(plugins)]
    subprocess.check_output(cmd, stderr=subprocess.STDOUT)
    print('[prerun] Plugins set.')

    
def check_main_db_connection(retry=None):

    conn_str = os.environ.get('DEV_CKAN_SQLALCHEMY_URL')
    if not conn_str:
        print('[prerun] DEV_CKAN_SQLALCHEMY_URL not defined, not checking db')
    return check_db_connection(conn_str, retry)


def check_db_connection(conn_str, retry=None):

    if retry is None:
        retry = RETRY
    elif retry == 0:
        print('[prerun] Giving up after 5 tries...')
        sys.exit(1)

    try:
        connection = psycopg2.connect(conn_str)

    except psycopg2.Error as e:
        print(str(e))
        print('[prerun] Unable to connect to the database, waiting...')
        time.sleep(10)
        check_db_connection(conn_str, retry=retry - 1)
    else:
        connection.close()

        
def check_solr_connection(retry=None):

    if retry is None:
        retry = RETRY
    elif retry == 0:
        print('[prerun] Giving up after 5 tries...')
        sys.exit(1)

    url = os.environ.get('DEV_CKAN_SOLR_URL', '')
    search_url = '{url}/select/?q=*&wt=json'.format(url=url)

    try:
        connection = urlopen(search_url)
    except URLError as e:
        print(str(e))
        print('[prerun] Unable to connect to solr, waiting...')
        time.sleep(10)
        check_solr_connection(retry=retry - 1)
    else:
        eval(connection.read())


def init_db(ini=ckan_ini):

    db_command = ['ckan', '-c', ini, 'db', 'init']
    print('[prerun] Initializing or upgrading db - start: {}'.format(ini))
    try:
        subprocess.check_output(db_command, stderr=subprocess.STDOUT)
        print('[prerun] Initializing or upgrading db - end')
    except subprocess.CalledProcessError as e:
        if 'OperationalError' in e.output:
            print(e.output)
            print('[prerun] Database not ready, waiting a bit before exit...')
            time.sleep(5)
            sys.exit(1)
        else:
            print(e.output)
            raise e


def create_sysadmin():

    name = os.environ.get('CKAN_SYSADMIN_NAME')
    password = os.environ.get('CKAN_SYSADMIN_PASSWORD')
    email = os.environ.get('CKAN_SYSADMIN_EMAIL')

    if name and password and email:

        # Check if user exists
        command = ['ckan', '-c', ckan_ini, 'user', 'show', name]

        out = subprocess.check_output(command)
        if 'User:None' not in re.sub(r'\s', '', str(out)):
            print('[prerun] Sysadmin user exists, skipping creation')
            return

        # Create user
        command = [
            'ckan', '-c', ckan_ini, 
            'user', 'add',
            name,
            'password=' + password,
            'email=' + email
        ]

        subprocess.call(command)
        print('[prerun] Created user {0}'.format(name))

        # Make it sysadmin
        command = [
            'ckan', '-c', ckan_ini,
            'sysadmin', 'add',
            name
        ]

        subprocess.call(command)
        print('[prerun] Made user {0} a sysadmin'.format(name))


if __name__ == '__main__':

    maintenance = os.environ.get('MAINTENANCE_MODE', '').lower() == 'true'

    if maintenance:
        print('[prerun] Maintenance mode, skipping setup...')
    else:
        check_main_db_connection()
        init_db()
        init_db(ini=test_ckan_ini)
        update_plugins()
        create_sysadmin()
        check_solr_connection()
