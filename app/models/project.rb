class Project < Work::Unit
  alias_method :phases, :children
  alias_method :customer, :parent

  validates :wuid,
            presence: true,
            format: {
                with: /\A[a-z\_\.0-9]+\z/,
                message: "only small letters and underscores allowed",
                allow_nil: true
            }

  def active_phase
    detect_active_phase || create_children
  end

  def is_connected_with_youtrack?
    opts && opts.has_key?("youtrack")
  end

  def label
    name
  end

  private

  def detect_active_phase
    children_class.where(ancestry: child_ancestry).active.last
  end

  def children_class
    Phase
  end
end