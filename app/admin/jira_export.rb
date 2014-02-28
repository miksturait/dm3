ActiveAdmin.register Jira::Export do
  menu parent: "Work Unit's", priority: 8

  controller do
    def new
      Jira::TimeEntriesExport.new.perform
      redirect_to admin_jira_exports_path, notice: 'Export done!'
    end
  end
end
