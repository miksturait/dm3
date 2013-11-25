class Company < Work::Unit
  alias_method :customers, :children

  validates :wuid,
            inclusion: {
                in: [],
                allow_nil: true,
                message: 'should be unset'
            }

  private

  def children_class
    Customer
  end
end