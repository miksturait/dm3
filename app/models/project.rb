class Project < Work::Unit
  alias_method :phases, :children
  alias_method :customer, :parent

  validates :wuid,
            presence: true,
            format:   {
                with:      /\A[a-z\_\.0-9]+\z/,
                message:   'only small letters and underscores allowed',
                allow_nil: true
            }

  def self.related_to_descendant_id(id)
    descendant_ids_query = Work::Unit.descendant_ids(id).to_sql
    where("id IN (#{descendant_ids_query}) OR id = #{id}")
  end

  def active_phase
    detect_active_phase || create_children
  end

  def is_connected_with_youtrack?
    opts && opts.has_key?('youtrack')
  end

  def label
    name
  end

  def work_unit_recreator_class
    if opts && opts.has_key?('youtrack')
      Youtrack::WorkUnitRecreator
    else
      NullServices::WorkUnitRecreator
    end
  end

  private

  def detect_active_phase
    children_class.where(ancestry: child_ancestry).active.last
  end

  def children_class
    Phase
  end
end
