# DM3-WTS [![Build Status](https://travis-ci.org/miksturait/dm3.png?branch=master)](https://travis-ci.org/miksturait/dm3) [![Code Climate](https://codeclimate.com/github/miksturait/dm3.png)](https://codeclimate.com/github/miksturait/dm3)

DiamondMine3-Work-Track&Schedule

Simply Scheduling per week / work unit / co-worker.
Additionaly it allows tracking workload per day / work unit / co-worker

## Prerequisites

#### Environment

* rvm or any other ruby manager that read .ruby-version files

#### Database setup

````bash
rake db:setup
````

## Testing

#### Running tests

    bundle exec spec

#### Test accounts

* *What are the test accounts provided by seed file (login/password)*

## Deployment

#### Staging


#### Production

## To the rescue!

#### Production console

#### Logs

#### Restarting server

#### Database dump

#### Other

Selectively exporting TimeEntries to JIRA

```ruby
export = Jira::Export.last
coworker = export.time_entry.coworker
Jira::TimeEntriesExportBatch.new(coworker, [export]).perform
```

## Contact information

* Michał Czyż @cs3b


