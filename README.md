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

## API
DateTime is represented by iso 8601 standard.

### GET /api/coworkers.json
*Returns coworkers*
```
[
  {
    'id' => 1,
    'name' => 'Jim',
    'email' => 'jim@mikstura.it'
  },
  ...
]
```

### GET /api/work_units.json
*Returns work units*
```
[
  {
    'id' => 1,
    'wuid' => 'wuid',
    'name' => 'project a',
    'ancestry' => '1/2',
    'type' => 'Project',
    'created_at' => '2014-02-05T15:00:00.000Z',
    'updated_at' => '2014-02-05T15:00:00.000Z',
    'period' => ...,
    'opts' => ...,
    'ancestry_depth' => 3
  },
  ...
]
```

#### Params
```parent_work_unit_id``` (optional) - it will return all descendants of specified parent

```depth``` (optional) - it will return work units not greater than depth


### GET /api/work_entries.json
*Returns work entries*
```
[
  {
    'id' => 1,
    'work_unit_id' => 1,
    'coworker_id' => 1,
    'start_time' => '2014-02-05T14:59:00Z',
    'end_time' => '2014-02-05T15:01:00Z',
    'duration' => 2,
    'coworker_name' => 'three',
    'comment' => 'c'
  },
  ...
]
```

#### Params
```page, limit``` (optional) - it will allow to paginate results

```coworker_ids[]``` (optional) - it will return work entries assigned to specified coworkers

```work_unit_id``` (optional) - it will return work entries assigned to specified work unit

```after``` (optional) - it will return work entries that started after specified time (after >= start_time)

```before``` (optional) - it will return work entries that started before specified time (before <= start_time)

#### Grouping
```group_by[]``` (optional) - it will return work entries but grouped by given criteria, allowed options for grouping are: ```day```, ```week```, ```month```, ```coworker```

##### Response when grouping is used
###### group by coworker
```
{
  '1' => [ # coworker id
    {
      # work entry data
    },
    ...
  ]
}
```

###### group by day, coworker
```
{
  '2014-02-05T00:00:00Z' => { # beginning of day
    '1' => [ # coworker id
      {
        # work entry data
      },
      ...
    ]
  }
}
```

##### Important notes about grouping
* two group options that are time related can not be used together
* maximum level of group nesting is two groups
