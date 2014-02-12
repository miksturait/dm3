# curl -u t.borowski@selleo.com:s3ll3o -v -H "Accept: application/json" -H "Content-type: application/json" -X POST \
#   -d "{ \"comment\": \"test api\", \"started\": \"2014-01-02T11:50:00.000+0000\", \"timeSpent\": \"10m\" }" \
#   https://vtelligence.atlassian.net/rest/api/2/issue/SPD-566/worklog\?adjustEstimate\=auto


#class Jira
#
#end
#
#describe JiraExport::Workload do
#
#  # example time entry for example project
#
#  # have an service class
#
#end

#class JiraAPI
#  include HTTParty
#  base_uri 'https://vtelligence.atlassian.net/jira/rest/api/2/'
#
#  def initialize()
#    @auth = {}
#    #time_entry.period.begin.utc.iso8601
#    def worklog(time, date, username, issue)
#      options = {
#          body:
#              {
#                  #self: "http://www.example.com/jira/rest/api/2/issue/10010/worklog/10000",
#                  author: {
#                      self: "http://www.example.com/jira/rest/api/2/user?username=michalczyz@gmail.com",
#                      updateAuthor: {
#                          self: "http://www.example.com/jira/rest/api/2/user?username=#{username}",
#                      },
#                      comment: ".",
#                      started: start_at,
#                      timeSpentSeconds: time,
#                  },
#                  basic_auth: {:username => 'michalczyz@gmail.com', :password => 'SUApP8yHvqhg'}
#              }
#      self.class.post("issue/#{issue}/worklog", options)
#    end
#  end
#end
