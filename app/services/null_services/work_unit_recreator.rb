module NullServices
  class WorkUnitRecreator < Struct.new(:project, :context_code)
    def recreate; end
  end
end
