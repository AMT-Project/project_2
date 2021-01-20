# Gamification engine
*Le Groupe 7* has developped a REST API to help you gamify your application.  Here is how you can create your own gamification engine.

## Start-up services
The following sections will tell you how to start and test your own gamification engine if you wish to expand it.

### Running REST-API

```bash
cd scripts
./runREST_API.sh
```

### Running REST-API latest (from github registry)
```bash
cd scripts
./pullREST_API.sh
```

### Test REST-API
```bash
cd gamification-specs
mvn clean test
```

## Use the gamification engine for your application

We provide several endpoints to help you gamify your application how you want it. We provide endpoints for:

* badges
* point-scales
* leaderboards
* rules

When your application is being used, you can update the gamification engine about your users by posting requests to the endpoint:

* events

You can get information about your users by using the endpoint:

* users

You can find a complete documentation of the api >here<.