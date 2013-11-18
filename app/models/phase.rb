# it have
# * one project
# * posted invoices
class Phase < Work::Unit
  alias_method :project, :parent
  alias_method :units, :children
end