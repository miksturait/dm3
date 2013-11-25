class Phase < Work::Unit
  alias_method :project, :parent
  alias_method :units, :children

  validates :wuid,
            inclusion: {
                in: [],
                allow_nil: true,
                message: 'should be unset'
            }

end