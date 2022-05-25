# Benchmark app

docker-compose.yaml is the starting point for the application
There are 3 services:
  - Rails web server
  - Postgres
  - Redis



1. Buid services:
  `docker-compose build`
2. Setup web service:
  `docker-compose run web sh`
  Then:
    `rake db:setup`
  [Optional] To see all available routes int Rails server:
  `rails routes`
3. `docker-compose up`


