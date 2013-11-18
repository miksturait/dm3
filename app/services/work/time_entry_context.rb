# based on the text description like:
# * hrm - feedback for WR
# * sourcyx-manage
# * sourcyx-jira::1235
# * ccc-132
# it returns hash, e.g.:
# {
#   workload_object: < Project / Milestone / Task >
#   comment: feedback for WR
# }
# if workload object is not find, then exception is raised

# if are not able to find and workload object
# and when node is redirecting to an external source e.g. youtrack, we are delegating
# context identification to specialize class

class Workload::TimeEntryContext
end