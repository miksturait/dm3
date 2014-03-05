module NullServices
  class WorkUnitRecreator < Struct.new(:project, :context_code)
    def recreate; end
    def leaf; end
  end
end
