# it have
# * one customer
# * posted invoices
# * one phase (with name 'current')
class Project < Work::Unit
  alias_method :phases, :children

  def active_phase
    children.last || children.create(type: 'Phase')
  end
end