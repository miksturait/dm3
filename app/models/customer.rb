class Customer < Work::Unit
  alias_method :projects, :children
  alias_method :company, :parent

  validates :wuid,
            inclusion: {
                in: [],
                allow_nil: true,
                message: 'should be unset'
            }

  private

  def children_class
    Project
  end
end