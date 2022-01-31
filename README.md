# README

## Setup

Run `./start-docker.sh` to run inside a Docker container with everything installed already, then run the commands below.

OR

Ensure you have `Ruby 3.1.0` installed and run `bundle install`, then run the commands below.


## Running

### Run Tests

```
rspec
```

### Start Server

```
./start-server.sh
```

## Endpoints
- http://localhost:3000/stats
- http://localhost:3000/health

## Todo
- Use https://github.com/travisjeffery/timecop for all specs involving time
- Add scopes to SatelliteEntry to make the ActiveRecord queries more readable
- Make satellite data URL injectable via environment variables
- Handle and test error cases for calling satellite data url and parsing the response
- Revisit the satellite_entries table. It shold have an id as a primary key, and possibly an index on data_updated_at depending on expected load.
