class Project < Work::Unit
  alias_method :phases, :children

  def active_phase
    children.last || children.create(type: 'Phase')
  end
end