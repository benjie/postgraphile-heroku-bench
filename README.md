# PostGraphile Heroku Free Tier Benchmark

## Results

```
+ autocannon -B 1 -c 35 -a 5000 -m POST -i query.graphql -H Accept=application/json -H Content-Type=application/graphql http://shrouded-plains-64047.herokuapp.com/
Running 5000 requests test @ http://shrouded-plains-64047.herokuapp.com/
35 connections

running [====================] 99%┌─────────┬───────┬───────┬───────┬───────┬──────────┬─────────┬──────────┐
│ Stat    │ 2.5%  │ 50%   │ 97.5% │ 99%   │ Avg      │ Stdev   │ Max      │
├─────────┼───────┼───────┼───────┼───────┼──────────┼─────────┼──────────┤
│ Latency │ 18 ms │ 32 ms │ 56 ms │ 61 ms │ 33.26 ms │ 9.61 ms │ 73.41 ms │
└─────────┴───────┴───────┴───────┴───────┴──────────┴─────────┴──────────┘
┌───────────┬────────┬────────┬────────┬────────┬────────┬─────────┬────────┐
│ Stat      │ 1%     │ 2.5%   │ 50%    │ 97.5%  │ Avg    │ Stdev   │ Min    │
├───────────┼────────┼────────┼────────┼────────┼────────┼─────────┼────────┤
│ Req/Sec   │ 877    │ 877    │ 1027   │ 1118   │ 993    │ 86.66   │ 877    │
├───────────┼────────┼────────┼────────┼────────┼────────┼─────────┼────────┤
│ Bytes/Sec │ 200 kB │ 200 kB │ 234 kB │ 255 kB │ 226 kB │ 19.7 kB │ 200 kB │
└───────────┴────────┴────────┴────────┴────────┴────────┴─────────┴────────┘

Req/Bytes counts sampled once per second.

5k requests in 5.05s, 1.13 MB read
Done in 5.31s.
```

## Running it for yourself

There's two parts to this: the server (`master` branch), and the benchmarker (`bench` branch).

First, spin up the server on Heroku:

1. Create a new heroku app (free tier); we'll call it SERVER_APP_NAME
2. Go to Resources / Add-ons and add heroku postgres (free tier)
3. Add this app as a remote: `git remote add server git@heroku.com:SERVER_APP_NAME.git`
4. Push the master branch to this new app (`git push server master:master`)

You should then be able to spin up any GraphQL client and point it at the dyno URL, e.g. http://SERVER_APP_NAME.herokuapp.com and run a GraphQL query.

Next, spin up the benchmarker:

1. Create a new heroku app; we'll call it BENCH_APP_NAME
2. Add this app as a remote: `git remote add bench git@heroku.com:BENCH_APP_NAME.git`
3. Push the `bench` branch to the new app's master branch: `git push bench bench:master`
4. Got to Resources, and turn off the `web` dyno
5. Change from Free Dynos to Professional dynos (this is for the benchmarker, not the thing being benchmarked!)
6. Run the benchmark: `heroku run -a BENCH_APP_NAME -s performance-l --env="BENCHMARK_URL=http://SERVER_APP_NAME.herokuapp.com/" -x -- "echo 'App wakeup'; sleep 15; yarn bench; echo 'Post-JIT bench'; yarn bench"`

All done. The benchmark should automatically exit. Now delete the Heroku apps you created.

Note the benchmark command gives a 15 second delay to let the dyno settle after boot, runs the benchmark once to warm up the server's JIT, and then runs the benchmark again.
