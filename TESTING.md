# Testing data.gov.uk

This page lists all the available testing tools used in the DGU dev and deployed stacks, how each test tool can be used and making developers aware of some of the testing tools available in CKAN core code.

## Frontend tests

Visual regression tests (VRT) check if there are any styling differences across the CKAN admin panel. This can be used to assess styling changes that could impact any of the views within the admin panel eg: between different versions of CKAN -

https://github.com/alphagov/datagovuk-visual-regression-tests

## Backend tests

### CKAN tests

As the CKAN tests are run and maintained by the CKAN team it's not really worth us also running the tests unless we want to make changes to some core CKAN code which we want to feed back upstream.

https://github.com/ckan/ckan/tree/master/ckan/tests

The CKAN tests can take a long time to run so it is not recommended that they are run on a regular basis. Also as the ckanext-datagovuk extension and other extensions override many of the core features and the default CKAN theme is significantly different many of the tests will fail or may pass for CKAN but is overridden by the extensions so this may give a false pass.

There are also some frontend JS tests which can be run against CKAN:

https://docs.ckan.org/en/2.8/contributing/test.html#automated-javascript-tests

As the amount of JS used within the DGU CKAN stack is limited and we don't really change the default behaviour of the CKAN JS, a decision has been made not to run these tests unless we change or extend the existing CKAN JS.

### CKAN API functional tests

These tests ensure that the API responses in CKAN produce an expected response for the most commonly used API endpoints in CKAN -

https://github.com/alphagov/ckan-functional-tests

### CKAN extension tests

https://github.com/alphagov/ckanext-datagovuk/ckanext/datagovuk/tests

https://github.com/alphagov/ckanext-harvest/ckanext/harvest/tests

https://github.com/alphagov/ckanext-spatial/ckanext/spatial/tests

https://github.com/alphagov/ckanext-dcat/ckanext/dcat/tests

Further details on how you can run these tests are given in the main [README](README.md/#running-tests-for-extensions) or in the github repos README themselves.

### Publish and Find tests

These are Ruby on Rails apps, to run the tests you will need to get onto the docker container and execute `bundle exec rspec`, or to target a particular test you can run `bundle exec rspec <the file and line number, eg ./spec/services/test_path.rb:100>`

https://github.com/alphagov/datagovuk_publish

https://github.com/alphagov/datagovuk_find

## Test data

In order to provide some test data to the dev stack a static and dynamic mock harvest source are available.

### Static harvest source 

Used to provide some initial test data for the dev stack, it is easily updated to provide any necessary responses for the developer investigating an issue or adding a feature.

https://github.com/alphagov/ckan-mock-harvest-sources/tree/master/static

### Dynamic harvest source

Used to test harvesting, can easily add additional harvest sources without deleting existing ones and can alter the number of datasets provided by the harvest source and a server lag for each request.

https://github.com/alphagov/ckan-mock-harvest-sources/tree/master/dynamic

## When to use these test tools

### Development

The [VRT tests](#frontend-tests) are useful to identify visual issues between different versions of CKAN, the alternative being manually testing each page. This would be inefficient, especially if a change was made to some common code shared between pages.

The [CKAN API functional tests](#ckan-api-functional-tests) will ensure that between different versions of CKAN the responses are consistent as some of our end users make use the of CKAN API calls, and since we don't make calls to all the APIs that end users call it would be difficult to ensure that they haven't been impacted during the migration process.

The CKAN mock harvest sources are also useful to setup scenarios for display of particular datasets or to investigate harvest issues.

### PR review

At the moment the only tests that are run as part of a PR review are unit tests for ckanext-datagovuk, Publish and Find. Although they are run as part of the PR review they are often ignored by developers if they fail.

### Deployment

Currently the only tests that we run on the DGU stack during deployment are for ckanext-datagovuk, Publish and Find. If the test fails then the deployment will not occur. 

### Smokey tests

Smokey tests have been set up to run at regular intervals:

https://github.com/alphagov/smokey/blob/master/features/data_gov_uk.feature

We should regularly review these tests to see if they are still needed or to add additional tests if there is not enough coverage for an important function of the DGU stack.

## Possible future work

### PR review processes

It would also be useful to consider adding some additional tests:

- add VRT as part of the PR review process when making changes that impact the frontend. Maybe run VRT in a CI pipeline
and create a link for dev to access the report.

- add CKAN API functional tests as part of the PR review process.

### Deployment

Something to think about:

- add some of the VRT tests as part of the CI pipeline, currently as they take about 15 minutes to run it would make deployment an even more arduous process than it currently is as puppet changes alone can take up to 30 minutes to take effect. So maybe a slimmed down version of the more important journeys. We could possibly send off a separate job on deployment that auto-updates the VRT repo with new views for it to store in source control. 
- If we decide to go down the continuous deployment route we run the VRT which will then auto approve and either commit to master or create a PR for review.

### Functional tests

Set up the CKAN functional API tests to run at regular intervals so that we are aware of any issues with the API endpoints as currently we only know of problems when users inform us. This might initially just run on Staging environment to ensure that we don't impact the servers.

### Full end to end test

There are currently no tests for the whole journey from adding/updating/deleting datasets/harvest source /publishers in CKAN to Find frontend. It would be useful to add in a number of tests which can be run on the docker dev stack and as an automated process, perhaps after the overnight sync.
