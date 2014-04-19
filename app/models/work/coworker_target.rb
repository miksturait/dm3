class Work::CoworkerTarget < Work::Target
  belongs_to :coworker, class_name: Coworker
end
