class Project < Work::Unit
  alias_method :phases, :children
  alias_method :customer, :parent

  validates :wuid,
            presence: true,
            format: {
                with: /\A[a-z\_\.]+\z/,
                message: "only small letters and underscores allowed",
                allow_nil: true
            }

  def active_phase
    children.last || create_children
  end

  private

  def children_class
    Phase
  end
end